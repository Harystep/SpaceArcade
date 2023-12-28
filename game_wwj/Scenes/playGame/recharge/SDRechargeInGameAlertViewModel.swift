//
//  SDRechargeInGameAlertViewModel.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit

import RxCocoa
import RxSwift

class SDRechargeInGameAlertViewModel: ViewModelType {
    
    typealias Dependency = HadUserManager & HadRechargeService & HadUserInfoServce
    
    
    let rechargeList: Driver<[SPRechargeSectionData]>;
    
    let coinValue: Driver<String>
    let pointValue: Driver<String>
    let moneyValue: Driver<String>

    let chargePayResult: Driver<Bool>;
    let chargePayAliPayResult: Driver<String>;

    required init(dependency: Dependency, bindings: Bindings) {
        rechargeList = bindings.fetchTrigger.withLatestFrom(bindings.rechargeTypeTrigger).flatMap { type in
            return dependency.rechargeService.getRechargeList(type: type).map { result in
//                if result.data != nil {
//                    return result.data!.normal;
//                }
//                return [];
                let resultData = result.data!
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
        }
        
        let userInfo = bindings.fetchUserInfoTrigger.asObservable().flatMapLatest { _ in
            log.debug("[fetchUserInfoTrigger] ----> ")
            return dependency.userInfoService.getUserInfo()
        }
        let userInfoTrigger = userInfo.filter { userInfo in
            userInfo != nil
        }.map { userInfo in
            userInfo!
        }
        /// 金币的 订阅
        coinValue = Observable.merge(userInfoTrigger).map { userInfo -> String in
            "\(userInfo.goldCoin)"
        }.asDriverOnErrorJustComplete()
                
        pointValue = Observable.merge(userInfoTrigger).map { userInfo -> String in
            "\(userInfo.points)"
        }.asDriverOnErrorJustComplete()
        
        moneyValue = Observable.merge(userInfoTrigger).map { userInfo -> String in
            "\(userInfo.money)"
        }.asDriverOnErrorJustComplete()
        
//        chargePayResult = bindings.didSelectedChargeItemTrigger.asObservable().flatMapLatest({ data -> Observable<SDEmptyResponse> in
//            log.debug("[现在开始发送充值请求] ---->")
//            return dependency.rechargeService.applyPay(orderId: "\(data.id)", payMoney: data.getApplyPayProductId()).asObservable()
//        }).flatMapLatest({ result -> Observable<Bool> in
//            log.debug("第一次支付结果 ---> \(result.getCode())")
//            if result.getCode() == 0 {
//                return dependency.rechargeService.finishCurrentPayment().asObservable()
//            } else {
//                return Observable.just(false);
//            }
//        }).asDriver(onErrorJustReturn: false)
        
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
    }
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let rechargeTypeTrigger: Driver<Int>
        /// 刷新 用户信息的 指示
        let fetchUserInfoTrigger: Driver<Void>
        
        let didSelectedChargeItemTrigger: Driver<(SPRechargeItemViewModel, SPPaySupportType)>
    }
}
