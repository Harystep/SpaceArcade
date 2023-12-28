//
//  SDInvitedCodeViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/22.
//

import UIKit
import RxSwift
import RxCocoa
import SPIndicator
class SDInvitedCodeViewModel: ViewModelType {
    typealias Dependency = HadHomeService & HadUserInfoServce & HadUserManager & HadCustomService
    let currentUser: Driver<SDUser>
    let inputCodeResult: Driver<Bool>

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
  
        self.inputCodeResult = bindings.inputInvitedCodeTrigger.asObservable().flatMap({ code in
            return dependency.customService.sendInvitedCode(code: code)
        }).do(onNext: { result in
            if result.getCode() != 0 {
                SPIndicator.present(title: result.getErrMsg(), haptic: .error);
            }
        }).map({ result -> Bool in
            return result.getCode() == 0;
        }).asDriverOnErrorJustComplete()
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let inputInvitedCodeTrigger: Driver<String>
    
    }
}
