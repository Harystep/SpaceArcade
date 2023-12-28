//
//  SDGameLogViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/6.
//

import UIKit
import RxSwift
import RxCocoa

class SDGameLogViewModel: ViewModelType {
    typealias Dependency = HadUserManager & HadUserInfoServce
    
    let dollLogPageList: Driver<SDDollLogPageData>
    
    let didSelectedItem: Driver<SDGameLogItemModel>

    
    
    required init(dependency: Dependency, bindings: Bindings) {
        
        dollLogPageList = bindings.requestLogPage.withLatestFrom(bindings.gameType) { (page, type) -> (Int, Int) in
            return (page, type)
        }.asObservable().flatMap { (arg) in
            let (page, type) = arg;
            return dependency.userInfoService.getDollLog(type: type, page: page)
        }.filter({ data in
            return data != nil;
        }).map({ data in
            return data!;
        }).asDriverOnErrorJustComplete();
        
        
        self.didSelectedItem = bindings.didSelected.withLatestFrom(bindings.logList) { (didSelected, list) -> (IndexPath, [SDGameLogItemModel]) in
            return ((didSelected, list))
        }.map { (arg) -> SDGameLogItemModel in
            let (didSelected, list) = arg;
            return list[didSelected.row]
        }
    }
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let requestLogPage: Driver<Int>;
        let didSelected: Driver<IndexPath>
        let logList: Driver<[SDGameLogItemModel]>
        let gameType: Driver<Int>
    }
}
