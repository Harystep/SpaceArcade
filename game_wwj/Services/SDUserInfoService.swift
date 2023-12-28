//
//  SDUserInfoService.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/11.
//

import UIKit
import RxSwift
import RxCocoa
import SPIndicator

protocol SDUserInfoServiceType {
    func getUserInfo() -> Single<SDUser?>
    func exchangeWelfareCode(code: String) -> Single<SDEmptyResponse>
    func getDollLog(type: Int, page: Int) -> Single<SDDollLogPageData?>
    func getDollLogDetail(id: String) -> Single<SDResponse<SDDollLogDetailData>>
    func dollSettleAppeal(id: String, reason: String) -> Single<SDEmptyResponse>
    func getDollAppealLog(_ page: Int) -> Single<SDAppealDollPageData?>
    func cancelAccount() -> Single<SDEmptyResponse>
    func getDollInfo(id: String) -> Single<SDEmptyResponse>
    func getDollMoneyList(source: Int,type: Int, page: Int) -> Single<SDMemberMoneyLogPageData?>
    func updateUserInfo(nickName: String?, avatar: String?) -> Single<SDEmptyResponse>
    func getDollAppealInfo(id: String) -> Single<SDAppealDollItemData?>;
}

class SDUserInfoService: SDUserInfoServiceType {
    func getDollAppealInfo(id: String) -> Single<SDAppealDollItemData?> {
        return client.request(UserAPIRouter.getDollAppealInfo(id)).do(onSuccess: { (result: SDResponse<SDAppealDollItemData>) in
            
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }
    }
    
    func updateUserInfo(nickName: String?, avatar: String?) -> RxSwift.Single<SDEmptyResponse> {
        return client.request(UserAPIRouter.updateUserInfo(nickName, avatar)).do(onSuccess: {
            (result: SDEmptyResponse) in
            if result.getCode() != 0 {
                DispatchQueue.main.async {
                    SPIndicator.present(title: result.getErrMsg(), haptic: .error);
                }
            }
        })
    }
    
    func getMemberGoodsPointList(type: Int, page: Int) -> RxSwift.Single<SDMemberMoneyLogPageData?> {
        return client.request(UserAPIRouter.getMemberGoodsPointList(type, page)).do(onSuccess: {
            (result: SDResponse<SDMemberMoneyLogPageData>) in
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func getDollMoneyForDiamondList(type: Int, page: Int) -> RxSwift.Single<SDResponse<SDMemberMoneyLogPageData>> {
        return client.request(UserAPIRouter.getDollMoneyForDiamondList(type, page)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func getDollMoneyList(source: Int, type: Int, page: Int) -> RxSwift.Single<SDMemberMoneyLogPageData?> {
        return client.request(UserAPIRouter.getDollMoneyList( source, type, page)).do(onSuccess: {
            (result: SDResponse<SDMemberMoneyLogPageData>) in
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func getDollInfo(id: String) -> RxSwift.Single<SDEmptyResponse> {
        return client.request(UserAPIRouter.getDollInfo(id)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func cancelAccount() -> RxSwift.Single<SDEmptyResponse> {
        return client.request(UserAPIRouter.cancelAccount).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func getDollAppealLog(_ page: Int) -> Single<SDAppealDollPageData?> {
        return client.request(UserAPIRouter.getDollAppealLog(page, 10)).do(onSuccess: { (response: SDResponse<SDAppealDollPageData>) in
            
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func dollSettleAppeal(id: String, reason: String) -> RxSwift.Single<SDEmptyResponse> {
        return client.request(UserAPIRouter.dollSettleAppeal(id, reason));
    }
    
    func getDollLogDetail(id: String) -> Single<SDResponse<SDDollLogDetailData>> {
        return client.request(UserAPIRouter.getDollSettleInfo(id));
    }
    
    func getDollLog(type: Int, page: Int) -> Single<SDDollLogPageData?> {
        return client.request(UserAPIRouter.getDollLog(type, page, 10)).do(onSuccess: { (result: SDResponse<SDDollLogPageData>) in
            
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }
    }
    
    func exchangeWelfareCode(code: String) -> Single<SDEmptyResponse> {
        return client.request(UserAPIRouter.exchangeWelfareCode(code));
    }
    
    
    private let client: ClientType
    private let userManager: LoginService
    
    init(client: ClientType, userService: LoginService) {
        self.client = client
        self.userManager = userService;
    }
    
    func getUserInfo() -> Single<SDUser?> {
        if let _ = SDUserManager.token {
            return client.request(UserAPIRouter.getUserInfo).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance).do(onSuccess: { (result: SDResponse<SDUser>) in
                    log.debug("[getUserInfo] ----> \(Thread.current)");
                    if result.errCode != 0 {
                        DispatchQueue.main.async {
                            SPIndicator.present(title: "警告", message: result.errMsg, haptic: .error);
                        }
                    }
            }).map { result in
                if result.errCode == 0 && result.data != nil {
                    return result.data!;
                }
                return nil;
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
        } else {
            return Single.just(nil);
        }
    }
}
