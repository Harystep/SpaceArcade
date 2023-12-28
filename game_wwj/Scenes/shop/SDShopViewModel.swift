//
//  SDShopViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/27.
//

import UIKit
import RxSwift
import RxCocoa

class SDShopViewModel: ViewModelType {
    typealias Dependency = HadHomeService & HadUserInfoServce & HadUserManager & HadRechargeService
    let currentUser: Driver<SDUser>
    let toLoginTrigger: Driver<Void>

    let chargeList: Driver<[SPRechargeSectionData]>
    let paySupportList: Driver<[SDPaySupportData]>
    
    let chargePayResult: Driver<Bool>;

    let chargePayAliPayResult: Driver<String>;
    
    required init(dependency: Dependency, bindings: Bindings) {
        let fetchUserInfo = bindings.fetchTrigger.asObservable().flatMapLatest { _ in
            return dependency.userInfoService.getUserInfo()
        }.filter({ user in
            return user != nil;
        }).map({ user -> SDUser in
            return user!;
        }).do(onNext: { user in
            dependency.usermanager.saveLocalUser(user);
        }).asDriverOnErrorJustComplete();
        
        let localUserInfo = dependency.usermanager.currentUser.filter({ user in
            return user != nil;
        }).map({ user -> SDUser in
            return user!;
        }).asDriverOnErrorJustComplete();
        
        self.currentUser = Observable.merge(fetchUserInfo.asObservable(), localUserInfo.asObservable()).asDriverOnErrorJustComplete();
        
//        bindings.fetchTrigger.asObservable().flatMapLatest { _ in
//            return dependency.rechargeService.getRechargeList(type: 2);
//        }.subscribe();
        let rechargeResult = bindings.chargeTypeTrigger.asObservable().flatMapLatest { chargeType in
            return dependency.rechargeService.getRechargeList(type: chargeType);
        }
        let chargeResultData = rechargeResult.filter { result in
            return result.errCode == 0
        }.map { result -> SDChargeTypeInfoData in
            return result.data!
        }
        self.paySupportList = chargeResultData.map({ result in
            return result.paySupport;
        }).asDriverOnErrorJustComplete();
        
        self.chargeList = chargeResultData.map { resultData -> [SPRechargeSectionData] in
            var list: [SPRechargeSectionData] = [];
            var cardList: [SPRechargeItemViewModel] = [];
            
            let paySupportList = resultData.paySupport.map { item in
                if item.payMode == 3 {
                    return SPPaySupportType.applePay;
                }
                return SPPaySupportType.aliPay;
            }
            
            if let weak = resultData.week {
                cardList.append(SPRechargeItemViewModel(originData: weak, type: .chargeForWeek, payList: paySupportList));
            }
            if let month = resultData.month {
                cardList.append(SPRechargeItemViewModel(originData: month, type: .chargeForMonth, payList: paySupportList));
            }
            if !cardList.isEmpty {
                list.append(SPRechargeSectionData(sectionType: .sectionForCard, list: cardList));
            }
            
            var normalSList : [SPRechargeItemViewModel] = [];
            if let first = resultData.first {
                normalSList.append(SPRechargeItemViewModel(originData: first, type: .chargeForFirst, payList: paySupportList));
            }
            let normalList = resultData.normal.map { item in
                return SPRechargeItemViewModel(originData: item, type: .chargeForNormal, payList: paySupportList);
            }
            normalSList.append(contentsOf: normalList);
            list.append(SPRechargeSectionData(sectionType: .sectionForNormal, list: normalSList));

            return list;
        }.asDriverOnErrorJustComplete();
        
        
        self.chargePayAliPayResult = bindings.didSelectedChargeItemTrigger.asObservable().filter { (arg) in
            let (data, payMethod) = arg;
            return payMethod == .aliPay;
        }.flatMap { (arg) in
            let (data, payMethod) = arg;
            var productId = "";
            if data.chargeType == .chargeForWeek || data.chargeType == .chargeForMonth {
                productId = "card:\(data.originData.id)"
            } else {
                productId = "option:\(data.originData.id)"
            }
            return dependency.rechargeService.aliPay(productId: productId).filter { payData in
                return payData != nil;
            }.map { payData -> String in
                return payData!;
            }
        }.asDriverOnErrorJustComplete();
        
        let notLogin = bindings.didSelectedChargeItemTrigger.asObservable().filter { (_, _) in
            return SDUserManager.token == nil;
        }.mapToVoid().asDriverOnErrorJustComplete()
        
        
        chargePayResult =  bindings.didSelectedChargeItemTrigger.asObservable().filter { (arg) in
            let (_, payMethod) = arg;
            return payMethod == .applePay;
        }.flatMapLatest { (arg) -> Observable<SDResponse<SDAppleOrderData>> in
            let (data, _) = arg;
            var productId = "";
            if data.chargeType == .chargeForWeek || data.chargeType == .chargeForMonth {
                productId = "card:\(data.originData.id)"
            } else {
                productId = "option:\(data.originData.id)"
            }
            return dependency.rechargeService.createAppleOrder(productId: productId).asObservable()
        }.filter { result in
            return result.getCode() == 0 && result.data != nil
        }.map { result in
            return result.data!;
        }.withLatestFrom(bindings.didSelectedChargeItemTrigger) { (orderData, arg) -> (SDAppleOrderData, SPRechargeItemViewModel, SPPaySupportType) in
            let (data, payMethod) = arg;
            return (orderData, data, payMethod);
        }.flatMapLatest { arg in
            let (orderData, data, payMethod) = arg;
            return dependency.rechargeService.applyPay(orderId: "\(orderData.orderSn)", payMoney: data.originData.getApplyPayProductId()).asObservable()
        }.flatMapLatest({ result -> Observable<Bool> in
            log.debug("第一次支付结果 ---> \(result.getCode())")
            if result.getCode() == 0 {
                return dependency.rechargeService.finishCurrentPayment().asObservable()
            } else {
                return Observable.just(false);
            }
        }).asDriver(onErrorJustReturn: false)
        
//        chargePayResult = bindings.didSelectedChargeItemTrigger.asObservable().filter { (arg) in
//            let (_, payMethod) = arg;
//            return payMethod == .applePay;
//        }.flatMapLatest({ (arg) -> Observable<SDEmptyResponse> in
//            let (data, _) = arg;
//            log.debug("[现在开始发送充值请求] ---->")
//            return dependency.rechargeService.applyPay(orderId: "\(data.originData.id)", payMoney: data.originData.getApplyPayProductId()).asObservable()
//        }).flatMapLatest({ result -> Observable<Bool> in
//            log.debug("第一次支付结果 ---> \(result.getCode())")
//            if result.getCode() == 0 {
//                return dependency.rechargeService.finishCurrentPayment().asObservable()
//            } else {
//                return Observable.just(false);
//            }
//        }).asDriver(onErrorJustReturn: false)
        self.toLoginTrigger = Driver.merge(bindings.toLoginTrigger, notLogin).do(onNext: { _ in
            dependency.usermanager.authenticationState = .signedOut;
        })
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let chargeTypeTrigger: Driver<Int>
        let didSelectedChargeItemTrigger: Driver<(SPRechargeItemViewModel, SPPaySupportType)>
        let toLoginTrigger: Driver<Void>
    }
}
