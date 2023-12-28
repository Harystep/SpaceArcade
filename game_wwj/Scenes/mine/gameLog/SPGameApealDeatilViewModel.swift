//
//  SPGameApealDeatilViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import RxSwift
import RxCocoa

class SPGameApealDeatilViewModel: ViewModelType {
    typealias Dependency = HadUserManager & HadUserInfoServce
    let appealResult: Driver<SDAppealDollItemData>
    required init(dependency: Dependency, bindings: Bindings) {
        self.appealResult = bindings.fetchTrigger.withLatestFrom(bindings.dollAppealIdTrigger).asObservable().flatMap { appelaId in
            return dependency.userInfoService.getDollAppealInfo(id: appelaId)
        }.asObservable().filter({ result in
            return result != nil
        }).map({ result in
            return result!;
        }).asDriverOnErrorJustComplete();
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let dollAppealIdTrigger: Driver<String>

    }
}
