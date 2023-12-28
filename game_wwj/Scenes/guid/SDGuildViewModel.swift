//
//  SDGuildViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/22.
//

import UIKit
import RxSwift
import RxCocoa

class SDGuildViewModel: ViewModelType {
    typealias Dependency = HadHomeService & HadUserInfoServce & HadUserManager & HadCustomService
   
    let guildList: Driver<[SDGameStrategyData]>
    required init(dependency: Dependency, bindings: Bindings) {
        self.guildList = bindings.fetchTrigger.asObservable().flatMap { _ in
            return dependency.homeService.getGameStrategy()
        }.asDriverOnErrorJustComplete()
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
    }
}
