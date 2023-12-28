//
//  SDLoginViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/2.
//

import UIKit
import RxSwift
import RxCocoa
class SDLoginViewModel: ViewModelType {
    typealias Dependency = HadUserManager;
    let didLoginByPhone: Driver<Void>;
    
    let fetching: Driver<Bool>
    let loggedIn: Driver<Bool>
    let toCloseTrigger: Driver<Void>
    
    required init(dependency: Dependency, bindings: Bindings) {
        self.didLoginByPhone = bindings.didLoginByPhone;
        
        
        let loggingIn = ActivityIndicator();
        let errorTracker = ErrorTracker()
        self.fetching = loggingIn.asDriver();
         

        
        
        let appleLogedIn = bindings.appleLoginTrigger.flatMap({ token in
            return dependency.usermanager.loginWithToken(token: token)
                .trackActivity(loggingIn)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        });
        
        let fastLogedIn = bindings.fastLoginTokenTrigger.flatMap({ token in            
            return dependency.usermanager.fastLoginWithToken(token: token)
                .trackActivity(loggingIn)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        });
        self.loggedIn = Driver.merge(appleLogedIn, fastLogedIn);
        
        self.toCloseTrigger = bindings.toCloseTrigger.do(onNext: { _ in
            dependency.usermanager.authenticationState = .signedNot;
        });
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let didLoginByPhone: Driver<Void>;
        let appleLoginTrigger: Driver<String>
        let toCloseTrigger: Driver<Void>
        let fastLoginTokenTrigger: Driver<String>
    }
}
