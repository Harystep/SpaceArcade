//
//  SDTcpResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

enum SDTCPResponseCMD : String {
case conn_r = "conn_r"
    case hb_r = "hb_r"
    case start_r = "start_r"
    case grab_r = "grab_r"
    case status = "status"
    case into_room = "into_room"
    case leave_room = "leave_room"
    case system = "system"
    case other_grab = "other_grab"
    case maintain = "maintain"
    case text_message = "text_message"
    case appointment_r = "appointment_r"
    case appointment_change = "appointment_change"
    case appointment_play = "appointment_play"
    case game_url = "game_url"
    case lock_room = "lock_room"
    case free_room = "free_room"
    case push_coin_r = "push_coin_r"
    case push_coin_result_r = "push_coin_result_r"
    case operate_r = "operate_r"
    case arcade_down_r = "arcade_down_r"
    case sega_arcade_down_r = "sega_arcade_down_r"
    case settlement_result_r = "settlement_result_r"
    case sa_settlement_result_r = "sa_settlement_result_r"
    case arcade_coin_r = "arcade_coin_r"
    case sega_arcade_coin_r = "sega_arcade_coin_r"
}

protocol SDTcpResponse: Codable {
    var cmd: String { get }
}

struct SDBaseTcpResponse: SDTcpResponse {
    var cmd: String
}
