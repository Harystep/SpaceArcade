//
//  SPGameLogDetailViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/10.
//

import UIKit

import RxSwift
import RxCocoa

class SPGameLogDetailViewModel: ViewModelType {
    typealias Dependency = HadUserManager & HadUserInfoServce
    
    let dollLogResult: Driver<[SDDollLogDetailSettelementData]>
    let complaintForResult: Driver<SDEmptyResponse>;


    required init(dependency: Dependency, bindings: Bindings) {
 
        dollLogResult =  bindings.fetchTrigger.withLatestFrom(bindings.dollLogInfoTrigger).filter { log in
            return log.type != 1;
        }.flatMapLatest { logInfo in
            return dependency.userInfoService.getDollLogDetail(id: "\(logInfo.id)").asDriverOnErrorJustComplete();
        }.map({ response in
            if response.getCode() == 0 {
                if let data = response.data {
                    return data.list;
                }
            }
            return [];
        })
        
        bindings.fetchTrigger.withLatestFrom(bindings.dollLogInfoTrigger).filter { log in
            return log.type == 1;
        }.flatMapLatest { logInfo in
            log.debug("[fetchTrigger] ---> \(logInfo.id)")
            return dependency.userInfoService.getDollInfo(id: "\(logInfo.id)").asDriverOnErrorJustComplete();
        }.asObservable().subscribe();
        
        
        complaintForResult = bindings.complaintForSettelementTrigger.flatMapLatest({ (data, reason) in
            return dependency.userInfoService.dollSettleAppeal(id: "\(data.id)", reason: reason).asDriverOnErrorJustComplete();
        })
        
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let dollLogIdTrigger: Driver<String>
        let dollLogInfoTrigger: Driver<SDDollLogData>
        let complaintForSettelementTrigger: Driver<(SDDollLogDetailSettelementData, String)>
    }
}
