//
//  SDGamePageViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import RxSwift
import RxCocoa

class SDGamePageViewModel: ViewModelType {
    
    
    typealias Dependency = HadHomeService & HadUserInfoServce & HadUserManager & HadCustomService
    
    let homeResponse: Driver<SDGameRoomTagPageData>
    let didSelectedItem: Driver<SDGameLiveRoomData>
    required init(dependency: Dependency, bindings: Bindings) {
        
        self.homeResponse = bindings.requestLogPage.withLatestFrom(bindings.homeGroupId) {
            (page, groupId) -> (Int, Int) in
            return (page, groupId)
        }.flatMap({ (arg) in
            let (page, groupId) = arg;
            return dependency.homeService.getHomeRoomData(groupId: groupId, page: page).asDriverOnErrorJustComplete()
        }).filter { data in
            return data != nil;
        }.map { data -> SDGameRoomTagPageData in
            return data!;
        }
        self.didSelectedItem = bindings.didSelectedItem.asObservable().flatMap { item in
            return dependency.homeService.enterMatchine(matchineSn: item.originData.machineSn).filter { data in
                return data != nil;
            }.map { data in
                return data!;
            }
        }.asDriverOnErrorJustComplete()
    }
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let homeGroupId: Driver<Int>;
        let requestLogPage: Driver<Int>;
        let didSelectedItem: Driver<SDGameRoomItemViewModel>
    }
}
