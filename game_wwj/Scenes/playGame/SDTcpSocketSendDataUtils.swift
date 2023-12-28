//
//  SDTcpSocketSendDataUtils.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

class SDTcpSocketSendDataUtils {
    static func getTcpOperate(postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintData(position: postion);
    }
    static func getSaintMoveDirction(dirction: SDGameDirctionForType, postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintMoveDirctionData(position: postion, direction: dirction.rawValue);
    }
    static func getSaintCoin(isNewGame: Bool, postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintCoinData(position: postion, isNewGame: isNewGame ? 1 : 0);
    }
    static func getSeatCoin(isNewGame: Bool, postion: Int, count: Int) -> SDBaseTcpData {
        return SDTcpSendSaintCoinData(position: postion, isNewGame: isNewGame ? 1 : 0, count: count);
    }
    static func getSaintStartFire(postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintPostionData(cmd: SDTCPCMD.fire.rawValue, position: postion);
    }
    static func getSaintEndFire(postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintPostionData(cmd: SDTCPCMD.fire_stop.rawValue, position: postion);
    }
    static func getSaintSingleFire(postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintPostionData(cmd: SDTCPCMD.fire_single.rawValue, position: postion);
    }
    static func getSaintFireDouble(postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintPostionData(cmd: SDTCPCMD.fire_double.rawValue, position: postion);
    }
    static func getSaintSettlement(postion: Int) -> SDBaseTcpData {
        return SDTcpSendSaintPostionData(cmd: SDTCPCMD.settlement.rawValue, position: postion);
    }
    static func getSaintArcadeDown(postion: Int, isLeave: Bool) -> SDBaseTcpData {
        return SDTcpSendSaintLeaveData(isLeave: isLeave ? 1 : 0, position: postion);
    }
    static func getLeaveRoom() -> SDBaseTcpData {
        return SDTcpSendTcpData(cmd: "leave");
    }
}
