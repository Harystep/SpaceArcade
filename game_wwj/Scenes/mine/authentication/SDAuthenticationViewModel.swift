//
//  SDAuthenticationViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/6.
//

import UIKit
import RxSwift
import RxCocoa


class SDAuthenticationViewModel: ViewModelType {
    typealias Dependency = HadCustomService;
    
    let authenticationResult: Driver<Bool>
    
    required init(dependency: Dependency, bindings: Bindings) {
        let userInput = Driver.combineLatest(bindings.inputYourName, bindings.inputYourID) {
            (inputYourName, inputYourId) -> (String, String) in
            return (inputYourName, inputYourId)
        }.filter { (inputYourName, inputYourId) in
            return inputYourName.count > 0 && inputYourId.count > 10;
        }
        authenticationResult = bindings.didSureTap.withLatestFrom(userInput).flatMap({ (arg) in
            let (inputYourName, inputYourId) = arg;
            return dependency.customService.sendAuthInto(name: inputYourName, card: inputYourId).asDriverOnErrorJustComplete()
        });
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let didSureTap: Driver<Void>
        let inputYourName: Driver<String>
        let inputYourID: Driver<String>
    }
}
