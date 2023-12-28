//
//  SPGameApealLogViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit
import RxSwift
import RxCocoa

class SPGameApealLogViewModel: ViewModelType {
    
    typealias Dependency = HadUserManager & HadUserInfoServce

    let gameComplaintList: Driver<SDAppealDollPageData>
    let didSelectedItem: Driver<SDGameComplaintViewModel>

    required init(dependency: Dependency, bindings: Bindings) {
        gameComplaintList = bindings.requestLogPage.flatMapLatest({ page in
            return dependency.userInfoService.getDollAppealLog(page).asDriverOnErrorJustComplete();
        }).filter({ data in
            return data != nil;
        }).map({ data in
            return data!;
        })
//        self.didSelectedItem = bindings.didSelected.withLatestFrom(bindings.logList) { (didSelected, list) -> (IndexPath, [SDGameLogItemModel]) in
//            return ((didSelected, list))
//        }.map { (arg) -> SDGameLogItemModel in
//            let (didSelected, list) = arg;
//            return list[didSelected.row]
//        }
        self.didSelectedItem = bindings.didSelected.withLatestFrom(bindings.appealList) { (didSelected, list) -> (IndexPath, [SDGameComplaintViewModel]) in
            return (didSelected, list)
        }.map { (arg) -> SDGameComplaintViewModel in
            let (didSelected, list) = arg;
            return list[didSelected.row]
        }
    }
    
    struct Bindings {
        let requestLogPage: Driver<Int>;
        let fetchTrigger: Driver<Void>
        let didSelected: Driver<IndexPath>
        let appealList: Driver<[SDGameComplaintViewModel]>
    }
}
