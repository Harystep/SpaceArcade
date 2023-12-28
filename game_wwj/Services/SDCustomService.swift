//
//  SDCustomService.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/10.
//

import UIKit

import RxSwift
import RxCocoa
import SPIndicator


protocol SDCustomServiceType {
    func getMemberAgreement() -> Single<String>
    func getMobileCaptcha(mobile: String) -> Single<Bool>
    func getSummaryRankForPoint(page: Int) -> Single<SDSummaryRankPageData?>
    func getSummaryRankForDiamond(page: Int) -> Single<SDSummaryRankPageData?>
    func getSignList() -> Single<SDSignListData?>
    func sendSign() -> Single<SDEmptyResponse>
    func sendInvitedCode(code: String) -> Single<SDEmptyResponse>
    func sendAuthInto(name: String, card: String) -> Single<Bool>
    func getGameRule(machineSn: String) -> Single<SDResponse<SDGameRuleModalData>>
}

class SDCustomService: SDCustomServiceType {
    func getGameRule(machineSn: String) -> RxSwift.Single<SDResponse<SDGameRuleModalData>> {
        return client.request(HomeAPIRouter.getGameRule(machineSn));
    }
    
    func sendAuthInto(name: String, card: String) -> Single<Bool> {
        return client.request(UserAPIRouter.sendAuthInfo(name, card)).do(onSuccess: {
            (result: SDEmptyResponse) in
            if result.getCode() != 0 {
                DispatchQueue.main.async {
                    SPIndicator.present(title: result.getErrMsg(), haptic: .error);
                }
            }
        }).map { result -> Bool in
            return result.getCode() == 0;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func sendInvitedCode(code: String) -> Single<SDEmptyResponse> {
        return client.request(UserAPIRouter.invitCode(code)).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func sendSign() -> RxSwift.Single<SDEmptyResponse> {
        return client.request(UserAPIRouter.sendSign).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    
    func getSignList() -> RxSwift.Single<SDSignListData?> {
        return client.request(UserAPIRouter.getSignList).do(onSuccess: {
            (result: SDResponse<SDSignListData>) in
        }).map { result -> SDSignListData? in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func getSummaryRankForDiamond(page: Int) -> RxSwift.Single<SDSummaryRankPageData?> {
        return client.request(UserAPIRouter.getSummaryRankForDiamond(page)).do(onSuccess: {
            (result: SDResponse<SDSummaryRankPageData>) in
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }
    }
    
    func getSummaryRankForPoint(page: Int) -> RxSwift.Single<SDSummaryRankPageData?> {
        return client.request(UserAPIRouter.getSummaryRankForPoint(page)).do(onSuccess: {
            (result: SDResponse<SDSummaryRankPageData>) in
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }
    }
    
    func getMobileCaptcha(mobile: String) -> RxSwift.Single<Bool> {
        return client.request(UserAPIRouter.getMobileCaptcha(mobile)).do(onSuccess: { (result: SDEmptyResponse) in
            
        }).map { result in
            if result.getCode() == 0 {
                return true;
            }
            return false;
        }
    }
    
    
    private let client: ClientType
    
    init(client: ClientType) {
        self.client = client
    }
    
    func getMemberAgreement() -> RxSwift.Single<String> {
        return client.request(UserAPIRouter.getMemberAgreement).do(onSuccess: { (result : SDResponse<SDAgreementData>) in
             
        }).map { result in
            if result.errCode == 0 && result.data != nil {
                return result.data!.agreement;
            }
            return "";
        }
    }
}
