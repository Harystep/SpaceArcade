//
//  SDUser.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit

struct SDUser: Codable {
    let memberId: Int?
//    let mobile: String;
    let money: String;
    let gender: Int;
    let avatar: String;
    let inviteCode: String;
    let aliasId: String;
    let type: Int;
    let goldCoin: Int;
    let nickname: String;
    let points: Int;
    let accessToken: SDAccessToken?
    let memberLevelDto: SPMemberLevelData?
    let isSign: Int?
    let account: Float;
    let authStatus: Int;    
}
struct SDAccessToken: Codable {
    let accessToken: String;
}
struct SPMemberLevelData: Codable {
    let id: Int;
    let channelId: Int;
//    let thumb: String;
    let level: Int;
    let name: String;
    let targetMoney: Float;
    let progress: Float;
    let tips: String;
}
