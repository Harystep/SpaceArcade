//
//  SDGameViewModel.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

import RxCocoa
import RxSwift

class SDGameViewModel: ViewModelType {
    typealias Dependency = HadUserManager & HadHomeService & HadTCPClientService & HadUserInfoServce & HadCustomService
    
    /// 进入游戏的 接口 请求返回参数
    let enterMatchineReponse: Driver<SDGameLiveRoomData?>
    /// 当 页面消失 之后 订阅
    let viewWillDisappearTrigger: Driver<Void>
    /// 发送 TCP 订阅
    let sendTcpDataTrigger: Driver<SDBaseTcpData>
    /// 关闭 订阅
    let closeTrigger: Driver<Void>
    
    let coinValue: Driver<String>
    
    let pointValue: Driver<String>
    
    let seatPlayerList: Driver<[SDSaintSeatInfoData]>
    
    let onlookerPlayerList: Driver<[SDGamePlayerData]>
    
    let gameStatusTrigger: Driver<SDGamePlayStatus>
    
    let gameErrorMessageTrigger: Driver<String>
    
    let receviceTcpSettlementPointResult: Driver<Int>
    
    let onRechargeGameMoneyForCoinTrigger: Driver<Void>
    
    let onRechargeGameMoneyForPointsTrigger: Driver<Void>
    
    let connectedTimeOutTrigger: Driver<SDTcpConnectedResponse>;
    
    let gameFuncTrigger: Driver<SDFuncTag>
    
    let gameUserInfo: Driver<SDUser>
    
    let getGameRuleTrigger: Driver<String>
    
    required init(dependency: Dependency, bindings: Bindings) {
        closeTrigger = bindings.closeTrigger
        
        onRechargeGameMoneyForCoinTrigger = bindings.onRechargeGameMoneyForCoinTrigger;
        onRechargeGameMoneyForPointsTrigger = bindings.onRechargeGameMoneyForPointsTrigger;
        gameFuncTrigger = bindings.gameFuncTrigger;
        viewWillDisappearTrigger = bindings.viewWillDisappearTrigger.do(onNext: { _ in
            dependency.tcpClientService.disconnectSocket()
        })
        
        sendTcpDataTrigger = bindings.sendTcpData.withLatestFrom(bindings.enterMatchineTrigger) { data, matchineSn -> SDBaseTcpData in
            var sendData = data
            sendData.updateVmcNo(matchineSn)
            return sendData
        }.do(onNext: { data in
            dependency.tcpClientService.sendTcpData(data: data)
        })
        enterMatchineReponse = bindings.fetchTrigger.asObservable().withLatestFrom(bindings.enterMatchineTrigger).do(onNext: { matchineSn in
            dependency.tcpClientService.connectSocket(matchineSn: matchineSn)
        }).flatMapLatest { matchineSn in
            dependency.homeService.enterMatchine(matchineSn: matchineSn)
        }.asDriverOnErrorJustComplete()
        
        let userInfo = bindings.fetchUserInfoTrigger.asObservable().flatMapLatest { _ in
            log.debug("[fetchUserInfoTrigger] ----> ")
            return dependency.userInfoService.getUserInfo()
        }
        let userInfoTrigger = userInfo.filter { userInfo in
            userInfo != nil
        }.map { userInfo in
            userInfo!
        }
        self.gameUserInfo = userInfoTrigger.asDriverOnErrorJustComplete();
        /// 金币的 订阅
        
        let coinValueFromUserInfo = userInfoTrigger.map { userInfo -> String in
            "\(userInfo.goldCoin)"
        };
        
        let cointValueFromStartGame = dependency.tcpClientService.receviceTcpDataForOperateResult.flatMapLatest { _ in
            return dependency.userInfoService.getUserInfo()
        }.filter { userInfo in
            userInfo != nil
        }.map { userInfo in
            userInfo!
        }.map { userInfo -> String in
            "\(userInfo.goldCoin)"
        };
        let cointValueFromArcadeCoin = dependency.tcpClientService.receviceTcpDataForArcadeCoinResult.filter({ reuslt in
            return reuslt.leftCoin != nil;
        }).asObservable().map { result in
            return "\(result.leftCoin!)"
        }
        
        coinValue = Observable.of(coinValueFromUserInfo, cointValueFromStartGame, cointValueFromArcadeCoin).merge().asDriverOnErrorJustComplete();
        
        
        /// 积分的 订阅
        pointValue = Observable.merge(userInfoTrigger).map { userInfo -> String in
            "\(userInfo.points)"
        }.asDriverOnErrorJustComplete()
        
        /// 当前正在完的人 订阅
        seatPlayerList = SDGameViewModel.getSeatPlayerList(dependency);
        
        /// 围观的人 订阅
        onlookerPlayerList = dependency.tcpClientService.receviceTcpDataForConnectedResult.asObserver().map { response in
            response.players
        }.asDriverOnErrorJustComplete()
        
        gameStatusTrigger = SDGameViewModel.getGameStatusTriggerFromReceviceTcpData(dependency, bindings);
        
        gameErrorMessageTrigger = SDGameViewModel.getGameErrorMessageTriggerFromReceviceTcpData(dependency);
        
        receviceTcpSettlementPointResult = dependency.tcpClientService.receviceTcpDataForSettlementResult.asObserver().filter { response in
            return response.status == 200;
        }.map { response in
            return response.points;
        }.asDriverOnErrorJustComplete();
        
        connectedTimeOutTrigger = dependency.tcpClientService.receviceTcpDataForConnectedResult.timeout(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance).asDriverOnErrorJustComplete();
        self.getGameRuleTrigger = bindings.gameFuncTrigger.filter { tag in
            return tag == .rule_func;
        }.asObservable().mapToVoid().withLatestFrom(bindings.enterMatchineTrigger).flatMap({ machineSn in
            return dependency.customService.getGameRule(machineSn: machineSn);
        }).map({ result in
            if result.getCode() == 0  {
                return result.data!.rule;
            }
            return "";
        }).asDriverOnErrorJustComplete();
    }
    
    struct Bindings {
        /// 当进入 页面的触发
        let fetchTrigger: Driver<Void>
        /// 记录 设备的 sn
        let enterMatchineTrigger: Driver<String>
        /// 设备的类型
        let matchineTypeTrigger: Driver<Int>
        /// 当 页面消失 之后
        let viewWillDisappearTrigger: Driver<Void>
        /// 发送 tcp
        let sendTcpData: Driver<SDBaseTcpData>
        /// 关闭 通知
        let closeTrigger: Driver<Void>
        /// 刷新 用户信息的 指示
        let fetchUserInfoTrigger: Driver<Void>
        
        let onRechargeGameMoneyForCoinTrigger: Driver<Void>
        
        let onRechargeGameMoneyForPointsTrigger: Driver<Void>
        
        let gameFuncTrigger: Driver<SDFuncTag>
    }
    
    deinit {
        log.debug("[SDGameViewModel] ---> deinit")
    }
}

private extension SDGameViewModel {
    static func getGameStatusFromReceviceConnectedTcpData(_ response: SDTcpConnectedResponse, type: Int) -> SDGamePlayStatus {
        let room_status = response.room_status
        var gameStatus = SDGamePlayStatus.define
        if room_status == 1 {
            gameStatus = SDGamePlayStatus.otherPlaying
        } else {
            if response.appointmentCount > 0 {
                gameStatus = SDGamePlayStatus.otherPlaying
            } else {
                gameStatus = SDGamePlayStatus.define
            }
        }
        if type == 4 {
            var isGame = 0
            response.seats.forEach { (data: SDSaintSeatInfoData) in
                if data.memberId == response.memberId {
                    isGame = data.isGame
                }
            }
            if isGame == 1 {
                gameStatus = SDGamePlayStatus.selfPlaying
            }
        }
        return gameStatus
    }

    static func getGameStatusFromReceviceStatusTcpData(_ response: SDTcpStatusResponse, type: Int, userId: Int) -> SDGamePlayStatus {
        if type != 4 {
            if response.gameStatus == 1 {
                return SDGamePlayStatus.otherPlaying
            } else {
                return SDGamePlayStatus.define
            }
        } else {
            if let seats = response.seats {
                var isGame = 0
                seats.forEach { (data: SDSaintSeatInfoData) in
                    if data.memberId == userId {
                        isGame = data.isGame
                    }
                }
                if isGame == 1 {
                    return SDGamePlayStatus.selfPlaying
                }
            }
        }
        return SDGamePlayStatus.define
    }
    
    static func getGameErrorMessageTriggerFromReceviceTcpData(_ dependency: Dependency) -> Driver<String> {
        let gameErrorMessageWithStartTrigger = dependency.tcpClientService.receviceTcpDataForStartResult.filter { response in
            return response.status != 200
        }.map { response in
            response.msg
        }.asDriverOnErrorJustComplete();
        let gameErrorMessageWithOperateTrigger = dependency.tcpClientService.receviceTcpDataForOperateResult.filter { response in
            return response.status != 200
        }.map { response in
            return response.msg;
        }.asDriverOnErrorJustComplete();
        
        let gameErrorMessageWithArcadeCoinTrigger = dependency.tcpClientService.receviceTcpDataForArcadeCoinResult.filter { response in
            return response.status != 200
        }.map { response in
            return response.msg;
        }.asDriverOnErrorJustComplete();
        
        let gameErrorMessageWithPushCoinTrigger = dependency.tcpClientService.receviceTcpDataForPushCoinResult.filter { response in
            return response.status != 200
        }.map { response in
            return response.msg;
        }.asDriverOnErrorJustComplete();
        
        
        return Driver.merge(gameErrorMessageWithStartTrigger, gameErrorMessageWithOperateTrigger, gameErrorMessageWithArcadeCoinTrigger, gameErrorMessageWithPushCoinTrigger)
    }
    
    static func getGameStatusTriggerFromReceviceTcpData(_ dependency: Dependency, _ bindings: Bindings) -> Driver<SDGamePlayStatus> {
        let gameStatusByReceviceConnectedTcpData = dependency.tcpClientService.receviceTcpDataForConnectedResult.withLatestFrom(bindings.matchineTypeTrigger) { response, matchineType -> (SDTcpConnectedResponse, Int) in
            (response, matchineType)
        }.map { (response: SDTcpConnectedResponse, matchineType: Int) in
            SDGameViewModel.getGameStatusFromReceviceConnectedTcpData(response, type: matchineType)
        }.asDriverOnErrorJustComplete()
        
        let gameStatusByReceviceStartedTcpData = dependency.tcpClientService.receviceTcpDataForStartResult.filter { response in
            response.status == 200
        }.map { _ in
            SDGamePlayStatus.selfPlaying
        }.asDriverOnErrorJustComplete()
        
        let gameStatusByReceviceEndGameTcpData = dependency.tcpClientService.receviceTcpDataForEndGameResult.map { _ in
            SDGamePlayStatus.define
        }.asDriverOnErrorJustComplete()
        
        let gameStatusByReceviceOperateTcpData = dependency.tcpClientService.receviceTcpDataForOperateResult.filter { response in
            response.status == 200
        }.map { _ in
            SDGamePlayStatus.selfPlaying
        }.asDriverOnErrorJustComplete()
        
        let gameStatusByReceviceStatusTcpData = Driver.combineLatest(dependency.tcpClientService.receviceTcpDataForStatusResult.asDriverOnErrorJustComplete(), bindings.matchineTypeTrigger, dependency.tcpClientService.receviceTcpDataForConnectedResult.asDriverOnErrorJustComplete()) { response, matchineType, connectedResponse -> (SDTcpStatusResponse, Int, SDTcpConnectedResponse) in
            (response, matchineType, connectedResponse)
        }.map { response, matchineType, connectedResponse in
            SDGameViewModel.getGameStatusFromReceviceStatusTcpData(response, type: matchineType, userId: connectedResponse.memberId)
        }
        
        return Observable.of(gameStatusByReceviceConnectedTcpData, gameStatusByReceviceStartedTcpData, gameStatusByReceviceEndGameTcpData, gameStatusByReceviceOperateTcpData, gameStatusByReceviceStatusTcpData).merge().asDriverOnErrorJustComplete();
    }
    static func getSeatPlayerList(_ dependency: Dependency) -> Driver<[SDSaintSeatInfoData]> {
        let playerListFromConnected = dependency.tcpClientService.receviceTcpDataForConnectedResult.asObserver().map { response in
            let new_seats = response.seats.map { data in
                var seatData = data
                if data.memberId == response.memberId {
                    seatData.isSelf = true
                } else {
                    seatData.isSelf = false
                }
                return seatData
            }
            return new_seats
        }.asDriverOnErrorJustComplete()
        
        let playerListFromStatus = dependency.tcpClientService.receviceTcpDataForStatusResult.withLatestFrom(dependency.tcpClientService.receviceTcpDataForConnectedResult) {
            (statusResponse, connectedResponse) -> (SDTcpStatusResponse, SDTcpConnectedResponse) in
            return (statusResponse, connectedResponse);
        }.map { (statusResponse, connectedResponse) -> [SDSaintSeatInfoData] in
            let new_seats = statusResponse.seats?.map { data in
                var seatData = data
                if data.memberId == connectedResponse.memberId {
                    seatData.isSelf = true
                } else {
                    seatData.isSelf = false
                }
                return seatData
            }
            guard new_seats != nil else { return [] }
            return new_seats!;
        }.asDriverOnErrorJustComplete()
        return Driver.merge(playerListFromStatus, playerListFromConnected);
    }
}
