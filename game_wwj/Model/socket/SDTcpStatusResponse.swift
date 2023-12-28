//
//  SDTcpStatusResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpStatusResponse: SDTcpResponse {
    var cmd: String
    let member_count: Int;
    let appointmentCount: Int?
    let players: [SDGamePlayerData]?
    let gameStatus: Int;
    let nickname: String?
    let headUrl: String?
    let seats: [SDSaintSeatInfoData]?;
    let player_id: Int;
}
