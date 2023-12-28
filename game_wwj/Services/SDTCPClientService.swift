//
//  SDTCPClientService.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit
import CocoaAsyncSocket
import RxCocoa
import RxSwift


protocol SDTCPClientServiceType {
    // 主动链接 tcp
    func connectSocket(matchineSn: String)
    // 主动 断开 链接
    func disconnectSocket();
    
    func sendConnectingSocketedSerivce();
    
    func sendTcpData(data: SDBaseTcpData);
    
    var receviceTcpDataForConnectedResult: PublishSubject<SDTcpConnectedResponse> { get }
    
    var receviceTcpDataForStartResult: PublishSubject<SDTcpStartResponse> { get }
    
    var receviceTcpDataForEndGameResult: PublishSubject<SDTcpGrapResponse> { get }
    
    var receviceTcpDataForStatusResult: PublishSubject<SDTcpStatusResponse> { get }
    
    var receviceTcpDataForSystemResult: PublishSubject<SDTcpSystemResponse> { get }
    
    var receviceTcpDataForOtherGrapResult: PublishSubject<SDTcpOtherGrabResponse> { get }
    
    var receviceTcpDataForMaintainErrorResult: PublishSubject<SDTcpResponse> { get }
    
    var receviceTcpDataForTextMessageResult: PublishSubject<SDTcpTextMessageResponse> { get }
    
    var receviceTcpDataForAppointmentResult: PublishSubject<SDTcpAppointmentResponse> { get }
    
    var receviceTcpDataForAppointmentChangeResult: PublishSubject<SDTcpAppointmentChangeResponse> { get }
    
    var receviceTcpDataForAppointmentPlayresult: PublishSubject<SDTcpAppointmentPlayResponse> { get }
    
    var receviceTcpDataForGameUrlResult: PublishSubject<SDTcpGameUrlResponse> { get }
    
    var receviceTcpDataForPushCoinResult: PublishSubject<SDTcpPushCoinResponse> { get }
    
    var receviceTcpDataForPushCoinResultResult: PublishSubject<SDTcpPushCoinResponse> { get }
    
    var receviceTcpDataForOperateResult: PublishSubject<SDTcpOperateResponse> { get }
    
    var receviceTcpDataForSettlementResult: PublishSubject<SDTcpSettlementResponse> { get }
    
    var receviceTcpDataForArcadeCoinResult: PublishSubject<SDTcpArcadeCoinResponse> { get }
}

class SDTCPClientService: SDTCPClientServiceType {
    
    var receviceTcpDataForArcadeCoinResult: RxSwift.PublishSubject<SDTcpArcadeCoinResponse> = PublishSubject<SDTcpArcadeCoinResponse> ();
    
    var receviceTcpDataForSettlementResult: RxSwift.PublishSubject<SDTcpSettlementResponse> = PublishSubject<SDTcpSettlementResponse> ();
    
    var receviceTcpDataForOperateResult: RxSwift.PublishSubject<SDTcpOperateResponse> = PublishSubject<SDTcpOperateResponse> ();
    
    var receviceTcpDataForPushCoinResultResult: RxSwift.PublishSubject<SDTcpPushCoinResponse> = PublishSubject<SDTcpPushCoinResponse> ();
    
    var receviceTcpDataForPushCoinResult: RxSwift.PublishSubject<SDTcpPushCoinResponse> = PublishSubject<SDTcpPushCoinResponse> ();
    
    var receviceTcpDataForGameUrlResult: RxSwift.PublishSubject<SDTcpGameUrlResponse> = PublishSubject<SDTcpGameUrlResponse> ();
    
    var receviceTcpDataForAppointmentPlayresult: RxSwift.PublishSubject<SDTcpAppointmentPlayResponse>  = PublishSubject<SDTcpAppointmentPlayResponse> ();
    
    var receviceTcpDataForAppointmentChangeResult: RxSwift.PublishSubject<SDTcpAppointmentChangeResponse> = PublishSubject<SDTcpAppointmentChangeResponse> ();
     
    var receviceTcpDataForAppointmentResult: RxSwift.PublishSubject<SDTcpAppointmentResponse> = PublishSubject<SDTcpAppointmentResponse> ();
    
    var receviceTcpDataForTextMessageResult: RxSwift.PublishSubject<SDTcpTextMessageResponse> = PublishSubject<SDTcpTextMessageResponse> ();
    
    var receviceTcpDataForMaintainErrorResult: RxSwift.PublishSubject<SDTcpResponse> = PublishSubject<SDTcpResponse> ();
    
    var receviceTcpDataForOtherGrapResult: RxSwift.PublishSubject<SDTcpOtherGrabResponse> = PublishSubject<SDTcpOtherGrabResponse> ();
    
    var receviceTcpDataForSystemResult: RxSwift.PublishSubject<SDTcpSystemResponse> = PublishSubject<SDTcpSystemResponse> ();
    
    var receviceTcpDataForStatusResult: RxSwift.PublishSubject<SDTcpStatusResponse> = PublishSubject<SDTcpStatusResponse> ();

    var receviceTcpDataForEndGameResult: RxSwift.PublishSubject<SDTcpGrapResponse> = PublishSubject<SDTcpGrapResponse> ();
    
    var receviceTcpDataForStartResult: RxSwift.PublishSubject<SDTcpStartResponse> = PublishSubject<SDTcpStartResponse> ();
    
    var receviceTcpDataForConnectedResult: RxSwift.PublishSubject<SDTcpConnectedResponse> = PublishSubject<SDTcpConnectedResponse>();
    
    func sendTcpData(data: SDBaseTcpData) {
        self.client.sendTcp(data: data);
    }
    func connectSocket(matchineSn: String) {
        self.matchineSn = matchineSn;
        self.client.connect(address: AppDefine.runTcpAddress, port: AppDefine.tcp_port, delegate: self);
    }
    
    func sendConnectingSocketedSerivce() {
        let sendData = SDTcpConnectData(cmd: SDTCPCMD.conn.rawValue, vmc_no: self.matchineSn!, token: SDUserManager.token!)
        self.client.sendTcp(data: sendData);
    }
    func disconnectSocket() {
        self.client.disConnect();
    }
    let client : SDTCPClientType;
    
    // 主动心跳
    var headerTimer: Timer?
    // 记录 当前 链接的 设备的 SN
    private var matchineSn: String?;
    
    init() {
        self.client = SDTCPClient.init();
    }
}

private extension SDTCPClientService {
    // 心跳
    func startHeaderTimer() {
        if self.headerTimer != nil {
            self.headerTimer!.invalidate();
            self.headerTimer = nil;
        }
        self.headerTimer = Timer.init(timeInterval: 30, target: self, selector: #selector(heartTimerRuning), userInfo: nil, repeats: true);
        
        if self.headerTimer != nil {
            RunLoop.main.add(self.headerTimer!, forMode: .default);
        }
    }
    func stopHeaderTimer() {
        if self.headerTimer != nil {
            self.headerTimer!.invalidate();
            self.headerTimer = nil;
        }
    }
    
    @objc func heartTimerRuning() {
        log.debug("[执行心跳] ------> ");
        let sendData = SDTcpHeartData(cmd: SDTCPCMD.hb.rawValue, vmc_no: SDUserManager.token!);
        self.client.sendTcp(data: sendData);
    }
}

extension SDTCPClientService: SDTCPClientDelegate {
    func readTcpData(_ cmd: SDTCPResponseCMD, receviceData: Data) {
        switch cmd {
        case .conn_r:
            do {
                let data = try JSONDecoder().decode(SDTcpConnectedResponse.self, from: receviceData)
                self.receviceTcpDataForConnectedResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForConnectedResult error: \(error)")
            }
            
            break;
        case .hb_r:
            break;
        case .start_r:
            do {
                let data = try JSONDecoder().decode(SDTcpStartResponse.self, from: receviceData)
                self.receviceTcpDataForStartResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForStartResult error: \(error)")
            }
            break;
        case .grab_r:
            do {
                let data = try JSONDecoder().decode(SDTcpGrapResponse.self, from: receviceData)
                self.receviceTcpDataForEndGameResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForEndGameResult error: \(error)")
            }
            break;
        case .status:
            do {
                let data = try JSONDecoder().decode(SDTcpStatusResponse.self, from: receviceData)
                self.receviceTcpDataForStatusResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForStatusResult error: \(error)")
            }
            break;
        case .into_room:
            do {
                let data = try JSONDecoder().decode(SDTcpSystemResponse.self, from: receviceData)
                self.receviceTcpDataForSystemResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForSystemResult error: \(error)")
            }
            break;
        case .leave_room:
            do {
                let data = try JSONDecoder().decode(SDTcpSystemResponse.self, from: receviceData)
                self.receviceTcpDataForSystemResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForSystemResult error: \(error)")
            }
            break;
        case .system:
            do {
                let data = try JSONDecoder().decode(SDTcpSystemResponse.self, from: receviceData)
                self.receviceTcpDataForSystemResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForSystemResult error: \(error)")
            }
            break;
        case .other_grab:
            do {
                let data = try JSONDecoder().decode(SDTcpOtherGrabResponse.self, from: receviceData)
                self.receviceTcpDataForOtherGrapResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForOtherGrapResult error: \(error)")
            }
            break;
        case .maintain:
            
            do {
                let data = try JSONDecoder().decode(SDBaseTcpResponse.self, from: receviceData)
                self.receviceTcpDataForMaintainErrorResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForMaintainErrorResult error: \(error)")
            }
            break;
        case .text_message:
            do {
                let data = try JSONDecoder().decode(SDTcpTextMessageResponse.self, from: receviceData)
                self.receviceTcpDataForTextMessageResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForTextMessageResult error: \(error)")
            }
            break;
        case .appointment_r:
            do {
                let data = try JSONDecoder().decode(SDTcpAppointmentResponse.self, from: receviceData)
                self.receviceTcpDataForAppointmentResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForAppointmentResult error: \(error)")
            }
            break;
        case .appointment_change:
            do {
                let data = try JSONDecoder().decode(SDTcpAppointmentChangeResponse.self, from: receviceData)
                self.receviceTcpDataForAppointmentChangeResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForAppointmentChangeResult error: \(error)")
            }
            break;
        case .appointment_play:
            do {
                let data = try JSONDecoder().decode(SDTcpAppointmentPlayResponse.self, from: receviceData)
                self.receviceTcpDataForAppointmentPlayresult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForAppointmentPlayresult error: \(error)")
            }
            break;
        case .game_url:
            do {
                let data = try JSONDecoder().decode(SDTcpGameUrlResponse.self, from: receviceData)
                self.receviceTcpDataForGameUrlResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForGameUrlResult error: \(error)")
            }
            break;
        case .lock_room:
            do {
                let data = try JSONDecoder().decode(SDBaseTcpResponse.self, from: receviceData)
                self.receviceTcpDataForMaintainErrorResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForMaintainErrorResult error: \(error)")

            }
            break;
        case .free_room:
            break;
        case .push_coin_r:
            do {
                let data = try JSONDecoder().decode(SDTcpPushCoinResponse.self, from: receviceData)
                self.receviceTcpDataForPushCoinResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForPushCoinResult error: \(error)")
            }
            break;
        case .push_coin_result_r:
            do {
                let data = try JSONDecoder().decode(SDTcpPushCoinResponse.self, from: receviceData)
                self.receviceTcpDataForPushCoinResultResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForPushCoinResultResult error: \(error)")
            }
            break;
        case .operate_r:
            do {
                let data = try JSONDecoder().decode(SDTcpOperateResponse.self, from: receviceData)
                self.receviceTcpDataForOperateResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForOperateResult error: \(error)")
            }
            break;
        case .arcade_down_r:
            
            do {
                let data = try JSONDecoder().decode(SDTcpGrapResponse.self, from: receviceData)
                self.receviceTcpDataForEndGameResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForEndGameResult error: \(error)")
            }
            
            break;
        case .sega_arcade_down_r:
            
            do {
                let data = try JSONDecoder().decode(SDTcpGrapResponse.self, from: receviceData)
                self.receviceTcpDataForEndGameResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForEndGameResult error: \(error)")
            }
            break;
        case .settlement_result_r:
            
            do {
                let data = try JSONDecoder().decode(SDTcpSettlementResponse.self, from: receviceData)
                self.receviceTcpDataForSettlementResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForSettlementResult error: \(error)")
            }
            
            break;
        case .sa_settlement_result_r:
            do {
                let data = try JSONDecoder().decode(SDTcpSettlementResponse.self, from: receviceData)
                self.receviceTcpDataForSettlementResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForSettlementResult error: \(error)")
            }
            break;
        case .arcade_coin_r:
        
            do {
                let data = try JSONDecoder().decode(SDTcpArcadeCoinResponse.self, from: receviceData)
                self.receviceTcpDataForArcadeCoinResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForArcadeCoinResult error: \(error)")
            }
            break;
        case .sega_arcade_coin_r:
            
            do {
                let data = try JSONDecoder().decode(SDTcpArcadeCoinResponse.self, from: receviceData)
                self.receviceTcpDataForArcadeCoinResult.onNext(data);
            } catch {
                log.debug("[readTcpData] ---> receviceTcpDataForArcadeCoinResult error: \(error)")
            }
            break;
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        self.startHeaderTimer();
        self.sendConnectingSocketedSerivce();
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.stopHeaderTimer();
    }
}
