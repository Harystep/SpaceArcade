//
//  SDTcpStartReponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpStartResponse: SDTcpResponse {
    var cmd: String
    let status: Int;
    let msg: String;
    let remainGold: String;
    let points: Int;
    let member_count: Int;
    let goldCoin: String;
    let nickname: String?
    let headUrl: String?
    let appointmentCount: Int;
}
