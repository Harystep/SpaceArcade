//
//  SDTcpConnectedReponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpConnectedResponse: SDTcpResponse {
    var cmd: String
    let status: Int;
    let msg: String;
    let headUrl: String;
    let nickname: String?
    let gold: String;
    let points: Int;
    let isGame: Int;
    let remainSecond: Int;
    let dollLogId: String;
    let appointmentCount: Int;
    let giveGold: Int;
    let memberId: Int;
    let coin: Int;
    let vmc_no: String;
    let member_count: Int;
    let room_status: Int;
    let gameUrl: String?;
    let profileUrl: String?;
    let players: [SDGamePlayerData];
    let seats: [SDSaintSeatInfoData];
}
struct SDGamePlayerData: Codable {
    let nickname: String;
    let avatar: String;
    let member_id: Int;
}
struct SDSaintSeatInfoData: Codable {
    let memberId: Int;
    let position: Int;
    let status: Int;
    let isGame: Int;
    let remainSecond: Int?;
    let startTime: Int;
    let times: Int;
    let headUrl: String;
    var isSelf: Bool? = false;
}
