//
//  SDLoginByPhoneViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/3.
//

import UIKit
import RxSwift
import RxCocoa

class SDLoginByPhoneViewModel: ViewModelType {
    
    typealias Dependency = HadUserManager & HadCustomService
    let cancelTaps: Driver<Void>
    let invitedCodeResult: Driver<Bool>
    let loggingIn: Driver<Bool>
    let isInviatedCodeValid: Driver<Bool>
    
    let isActionLoginValid: Driver<Bool>
    
    let loginResult: Driver<Bool>

    required init(dependency: Dependency, bindings: Bindings) {
        self.cancelTaps = bindings.cancelTaps;
        let loggingIn = ActivityIndicator()
        self.loggingIn = loggingIn.asDriver()
        
        
        let inputMobile = bindings.accountMobile.filter { mobile in
            return mobile.count == 11;
        }
        isInviatedCodeValid = bindings.accountMobile.map { mobile in
            return mobile.count != 11;
        }
        let userInput = Driver.combineLatest(bindings.accountMobile, bindings.invitedCode) {
            (mobile, invitedCode) -> (String, String) in
            return (mobile, invitedCode);
        }
        
        isActionLoginValid = userInput.map({ (mobile, invitedCode) in
            return mobile.count == 11 && invitedCode.count >= 4
        })
        
        
        self.invitedCodeResult = bindings.didInviteCode.asObservable()
            .withLatestFrom(inputMobile)
            .flatMap { mobile in
                return dependency.customService.getMobileCaptcha(mobile: mobile).trackActivity(loggingIn)
            }
            
            .asDriver(onErrorJustReturn: false)
        
        self.loginResult = bindings.didLoginTap.withLatestFrom(userInput).flatMap({ (arg) in
            let (mobile, invitedCode) = arg;
            return dependency.usermanager.login(mobile: mobile, code: invitedCode)
                .trackActivity(loggingIn)
                .asDriver(onErrorJustReturn: false)
        })
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let cancelTaps: Driver<Void>
        let didInviteCode: Driver<Void>
        let accountMobile: Driver<String>
        let invitedCode: Driver<String>
        let didLoginTap: Driver<Void>
    }
}
