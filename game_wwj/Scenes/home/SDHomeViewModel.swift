//
//  SDHomeViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/25.
//

import UIKit
import RxSwift
import RxCocoa

class SDHomeViewModel: ViewModelType {
    typealias Dependency = HadHomeService & HadUserInfoServce & HadUserManager & HadCustomService
    let currentUser: Driver<SDUser>
    let toLoginTrigger: Driver<Void>
    
    let signData: Driver<SDSignListData>;
    
    let showSignData: Driver<SDSignListData>;
    
    let bannerList: Driver<[SDBannerData]>
    
    
    let homeGroupList: Driver<[SDHomeGroupItem]>
    let homeGroupTrigger: Driver<SDHomeGroupItem>

    let functionGuidTrigger: Driver<SDGameGuidType>
    
    required init(dependency: Dependency, bindings: Bindings) {
                       
        let fetchUserInfo = bindings.fetchTrigger.asObservable().flatMapLatest { _ in
            return dependency.userInfoService.getUserInfo()
        }.filter({ user in
            return user != nil;
        }).map({ user -> SDUser in
            return user!;
        }).do(onNext: { user in
            dependency.usermanager.saveLocalUser(user);
        }).asDriverOnErrorJustComplete();
        
        let localUserInfo = dependency.usermanager.currentUser.filter({ user in
            return user != nil;
        }).map({ user -> SDUser in
            return user!;
        }).asDriverOnErrorJustComplete();
        
        self.currentUser = Observable.merge(fetchUserInfo.asObservable(), localUserInfo.asObservable()).asDriverOnErrorJustComplete();
      
        
        self.homeGroupList = bindings.fetchTrigger.asObservable().flatMap({ _ in
            return dependency.homeService.getHomeGroupList()
        }).retry(10000).asDriverOnErrorJustComplete();
        
        self.signData = bindings.fetchTrigger.asObservable().take(1).filter({ _ in
            return SDUserManager.token != nil;
        }).flatMap { _ in
            return dependency.customService.getSignList().filter { data in
                return data != nil;
            }.map { data -> SDSignListData in
                return data!
            }
        }.asDriverOnErrorJustComplete();
        
        self.showSignData = bindings.functionGuidTrigger.asObservable().filter({ guidType in
            return guidType == .GuidForSign
        }).filter({ _ in
            return SDUserManager.token != nil;
        }).flatMap { _ in
            return dependency.customService.getSignList().filter { data in
                return data != nil;
            }.map { data -> SDSignListData in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kSignResultKey"), object: data)
                return data!
            }
        }.asDriverOnErrorJustComplete();
        
        
        let showSignGuidToLogin = bindings.functionGuidTrigger.asObservable().filter({ guidType in
            return guidType == .GuidForSign
        }).filter({ _ in
            return SDUserManager.token == nil;
        }).do(onNext: { _ in
            dependency.usermanager.authenticationState = .signedOut
        }).asObservable().mapToVoid()
        
        self.bannerList = bindings.fetchTrigger.asObservable().flatMap({ _  in
            return dependency.homeService.getHomeBanner()
        }).asDriverOnErrorJustComplete()
        
        self.homeGroupTrigger = bindings.homeGroupTrigger.asObservable().filter({ _ in
            return SDUserManager.token != nil;
        }).withLatestFrom(self.homeGroupList) {
            (index, list) -> (Int, [SDHomeGroupItem]) in
            return (index, list)
        }.map({ (arg) in
            let (index, list) = arg;
            return list[index];
        }).asDriverOnErrorJustComplete();
        
        let homeGroupLoginTrigger = bindings.homeGroupTrigger.asObservable().filter({ _ in
            return SDUserManager.token == nil;
        }).mapToVoid().asDriverOnErrorJustComplete();
        
        self.functionGuidTrigger = bindings.functionGuidTrigger;
        
        self.toLoginTrigger = Driver.merge(bindings.toLoginTrigger, showSignGuidToLogin.asDriverOnErrorJustComplete(), homeGroupLoginTrigger).do(onNext: { _ in
            dependency.usermanager.authenticationState = .signedOut;
        });
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let toLoginTrigger: Driver<Void>
        let homeGroupTrigger: Driver<Int>
        let functionGuidTrigger: Driver<SDGameGuidType>
    }
}
