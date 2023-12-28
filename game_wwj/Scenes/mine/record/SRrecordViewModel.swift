//
//  SRrecordViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import RxSwift
import RxCocoa

class SRrecordViewModel: ViewModelType {
    typealias Dependency = HadUserManager & HadUserInfoServce
    
    let requestLogResult: Driver<SDMemberMoneyLogPageData>
    required init(dependency: Dependency, bindings: Bindings) {
        let typeTrigger = Driver.combineLatest(bindings.classTabIndexTrigger, bindings.comeTabIndexTrigger) {
            (classIndex, comeIndex) -> (Int, Int) in
            return (classIndex, comeIndex)
        }
        self.requestLogResult = bindings.requestLogPage.withLatestFrom(typeTrigger) { (page, arg) -> (Int, Int, Int) in
            let (classIndex, comeIndex) = arg;
            return (page, classIndex, comeIndex)
        }.asObservable().flatMap { (page, classIndex, comeIndex) in
            return dependency.userInfoService.getDollMoneyList(source: classIndex + 1, type: comeIndex == 0 ? 2 : 1, page: page);
        }.filter({ data in
            return data != nil;
        }).map({ data in
            return data!;
        }).asDriverOnErrorJustComplete();
    }
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let requestLogPage: Driver<Int>;
        let classTabIndexTrigger: Driver<Int>;
        let comeTabIndexTrigger: Driver<Int>;
    }
}
