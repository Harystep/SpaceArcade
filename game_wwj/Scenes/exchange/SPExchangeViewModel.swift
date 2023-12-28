//
//  SPExchangeViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/27.
//

import UIKit
import RxSwift
import RxCocoa

class SPExchangeViewModel: ViewModelType {
    typealias Dependency = HadHomeService & HadUserInfoServce & HadUserManager & HadRechargeService
    let currentUser: Driver<SDUser>

    let exchangeGoldList: Driver<[SPExchagneGoldData]>
    let exchangeGoldResult: Driver<Bool>
    
    let pmExchangePointResult: Driver<Bool>
    
    let toLoginTrgger: Driver<Void>
    
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
        
        
        self.exchangeGoldList = bindings.fetchTrigger.asObservable().flatMap { _ in
            return dependency.rechargeService.getExchangeGoldByPointList()
        }.asDriverOnErrorJustComplete();
        
        self.exchangeGoldResult =  bindings.sureExchagneTrigger.filter({ _ in
            return SDUserManager.token != nil;
        }).asObservable().flatMap { inputNum in
            return dependency.rechargeService.exchangeMemberGold(num: inputNum);
        }.map({ result -> Bool in
            return result.getCode() == 0
        }).asDriverOnErrorJustComplete();
        
        self.pmExchangePointResult = bindings.didSelectedExchangeGoldTrigger.asObservable().filter({ _ in
            return SDUserManager.token != nil;
        }).flatMap { model in
            return dependency.rechargeService.pmExchangePoint(optionId: model.originData.id);
        }.map({ result -> Bool in
            return result.getCode() == 0
        }).asDriverOnErrorJustComplete();
        
        let inputToLoginTrigger = bindings.sureExchagneTrigger.asObservable().filter({ _ in
            return SDUserManager.token == nil;
        }).asObservable().mapToVoid();
        let didiselectedToLoginTrigger = bindings.didSelectedExchangeGoldTrigger.asObservable().filter({ _ in
            return SDUserManager.token == nil;
        }).asObservable().mapToVoid();
        self.toLoginTrgger = Observable.merge(inputToLoginTrigger, didiselectedToLoginTrigger).do(onNext: { _ in
            dependency.usermanager.authenticationState = .signedOut
        }).asDriverOnErrorJustComplete()
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let sureExchagneTrigger: Driver<Int>
        let didSelectedExchangeGoldTrigger: Driver<SPExchangeGoldWithPointItemViewModel>;
    }
}
