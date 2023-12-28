//
//  SDRankViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/25.
//

import UIKit
import RxSwift
import RxCocoa

class SDRankViewModel: ViewModelType {
    typealias Dependency = HadHomeService & HadUserManager & HadCustomService
    
    let rankLogResult: Driver<SDSummaryRankPageData>;
    
    required init(dependency: Dependency, bindings: Bindings) {
        
        
        self.rankLogResult = bindings.requestLogPage.withLatestFrom(bindings.currentRankIndexTrigger) {
            (page, index) -> (Int, Int) in
            return (page, index);
        }.flatMap { (arg) in
            let (page, index) = arg;
            if (index == 0) {
                return dependency.customService.getSummaryRankForPoint(page: page).asDriverOnErrorJustComplete();
            }
            return dependency.customService.getSummaryRankForDiamond(page: page).asDriverOnErrorJustComplete();
        }.filter({ data in
            return data != nil;
        }).map({ data in
            return data!;
        })
        
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let requestLogPage: Driver<Int>
        let currentRankIndexTrigger: Driver<Int>
    }
}
