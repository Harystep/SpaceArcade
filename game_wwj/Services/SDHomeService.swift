//
//  SDHomeService.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit

import RxSwift
import SPIndicator
protocol SDHomeServiceType {
    func getHomeBanner() -> Single<[SDBannerData]>
    func enterMatchine(matchineSn: String) -> Single<SDGameLiveRoomData?>
    func getHomeRoomData(groupId: Int, page: Int) -> Single<SDGameRoomTagPageData?>
    func getHomeGroupList() -> Single<[SDHomeGroupItem]>
    func getGameStrategy() -> Single<[SDGameStrategyData]>
}

class SDHomeService: SDHomeServiceType {
    func getGameStrategy() -> Single<[SDGameStrategyData]> {
        return client.request(HomeAPIRouter.getGameStrategy).do(onSuccess: {
            (result: SDResponse<[SDGameStrategyData]>) in
        }).map { result in
            if result.getCode() == 0 && result.data != nil {
                return result.data!;
            }
            return [];
        }
    }
    
    
    func getHomeGroupList() -> RxSwift.Single<[SDHomeGroupItem]> {
        return client.request(HomeAPIRouter.getHomeGroup).do(onSuccess: {
            (result: SDResponse<[SDHomeGroupItem]>) in
        }).map { result in
            if result.getCode() == 0 && result.data != nil {
                return result.data!;
            }
            return [];
        }
    }
    
    func getHomeRoomData(groupId: Int, page: Int) -> RxSwift.Single<SDGameRoomTagPageData?> {
        return client.request(HomeAPIRouter.getHomeRoomWithType(groupId, page)).do(onSuccess: { [unowned self] (result: SDResponse<SDGameRoomTagPageData>) in
            if result.getCode() == 401 {
                self.userManager.loginWithError();
            }
        }).map { result in
            if result.getCode() == 0 && result.data != nil {
                return result.data!;
            } else {
                return nil;
            }
        }
    }
    
    func enterMatchine(matchineSn: String) -> RxSwift.Single<SDGameLiveRoomData?> {
        return client.request(HomeAPIRouter.enterMatchin(matchineSn)).do(onSuccess: {
            (result: SDResponse<SDGameLiveRoomData>) in
            if result.getCode() != 0 {
                DispatchQueue.main.async {
                    SPIndicator.present(title: "警告", message: result.errMsg, haptic: .error);
                }
            }
        }).map { result in
            if result.getCode() == 0 && result.data != nil {
                return result.data!;
            }
            return nil;
        }
    }
    
    func getHomeBanner() -> RxSwift.Single<[SDBannerData]> {
        return client.request(HomeAPIRouter.getHomeBanner(1)).do(onSuccess: { (result: SDResponse<[SDBannerData]>) in
            
        }).map { result -> [SDBannerData] in
            if result.errCode == 0 && result.data != nil {
                return result.data!;
            }
            return [];
        }
    }
    
    
    
    private let client: ClientType
    private let userManager: LoginService
    
    init(client: ClientType, userService: LoginService) {
        self.client = client
        self.userManager = userService;
    }
}
