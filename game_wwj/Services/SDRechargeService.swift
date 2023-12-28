//
//  SDRechargeService.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit
import RxCocoa
import RxSwift

import SPIndicator
import ProgressHUD

protocol SDRechargeServiceType {
    func getRechargeList(type: Int) -> Single<SDResponse<SDChargeTypeInfoData>>
    func applyPay(orderId: String, payMoney: String) -> Single<SDEmptyResponse>
    func aliPay(productId: String) -> Single<String?>
    func restoreCompletedTransactions() -> Single<SDEmptyResponse>
    func finishCurrentPayment() -> Single<Bool>;
    func getExchangeGoldByPointList() -> Single<[SPExchagneGoldData]>
    func exchangeMemberGold(num: Int) -> Single<SDEmptyResponse>
    func pmExchangePoint(optionId: Int) -> Single<SDEmptyResponse>;
    
    func createAppleOrder(productId: String) -> Single<SDResponse<SDAppleOrderData>>
}

class SDRechargeService: SDRechargeServiceType {
    func createAppleOrder(productId: String) -> RxSwift.Single<SDResponse<SDAppleOrderData>> {
        return client.request(SDRechargeAPIRouter.createAppleOrder(productId));
    }
    
    func pmExchangePoint(optionId: Int) -> RxSwift.Single<SDEmptyResponse> {
        return client.request(SDRechargeAPIRouter.pmExchangePoint(optionId)).do(onSuccess: {
            (result: SDEmptyResponse) in
            if result.getCode() != 0 {
//                DispatchQueue.main.async {
//                    SPIndicator.present(title: result.getErrMsg(), haptic: .error);
//                }

            }
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func exchangeMemberGold(num: Int) -> RxSwift.Single<SDEmptyResponse> {
        return client.request(SDRechargeAPIRouter.exchangeMemberGold(num)).do(onSuccess: {
            (result: SDEmptyResponse) in
//            if result.getCode() != 0 {
//                DispatchQueue.main.async {
//                    SPIndicator.present(title: result.getErrMsg(), haptic: .error);
//                }
//            }
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func getExchangeGoldByPointList() -> Single<[SPExchagneGoldData]> {
        return client.request(SDRechargeAPIRouter.getExchangeGlodByPointList).do(onSuccess: {
            (result: SDResponse<SPExchangeGoldWithPointData>) in
        }).map { result in
            if result.getCode() == 0 && result.data != nil {
                return result.data!.list;
            }
            return [];
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func aliPay(productId: String) -> RxSwift.Single<String?> {
        return client.request(SDRechargeAPIRouter.payChargeItemByAli(productId)).do(onSuccess: { (response: SDResponse<String>) in
            if response.getCode() != 0 {
                DispatchQueue.main.async {
                    SPIndicator.present(title: response.getMsg() ?? "" , haptic: .error);
                }
            }
        }).map { result -> String? in
            return result.data;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func finishCurrentPayment() -> RxSwift.Single<Bool> {
        return self.applyPayClient.finishCurrentPayment();
    }
    
    func applyPay(orderId: String, payMoney: String) -> Single<SDEmptyResponse> {
        self.applyPayClient.putCurrentPaymentProjectId(projectId: orderId);
        return self.applyPayClient.pay(payMoney).asObservable().flatMapLatest({[unowned self] (code, receipt) -> Observable<SDEmptyResponse> in
            if code == 0 {
                return client.request(SDRechargeAPIRouter.payChargeItemByApple(orderId, receipt)).asObservable()
            } else {
                return Observable.just(SDEmptyResponse(errCode: -1, errMsg: receipt, code: -1, msg: receipt, message: receipt));
            }
        }).asSingle()
    }
    
    func restoreCompletedTransactions() -> RxSwift.Single<SDEmptyResponse> {
        return self.applyPayClient.restoreCompletedTransactions().asObservable().flatMap { [unowned self] (code, receipt) -> Observable<SDEmptyResponse> in
            let orderId = self.applyPayClient.getLastPaymentProjectId();
            if code == 0 && orderId != nil {
                return client.request(SDRechargeAPIRouter.payChargeItemByApple(orderId!, receipt)).asObservable()
            } else {
                return Observable.just(SDEmptyResponse(errCode: -1, errMsg: receipt, code: -1, msg: receipt, message: receipt));
            }
        }.asSingle()
    }
    func getRechargeList(type: Int) -> RxSwift.Single<SDResponse<SDChargeTypeInfoData>> {
        return client.request(SDRechargeAPIRouter.chargeList(type)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    private let client: ClientType
    private let applyPayClient: ApplePayClientType;
    private let userManager: LoginService
    
    init(client: ClientType, userService: LoginService) {
        self.client = client
        self.userManager = userService;
        self.applyPayClient = SDApplePayClient.init();

    }
}

private extension SDRechargeService {
    
}
