//
//  SDDollLogDetailData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/25.
//

import UIKit

struct SDDollLogDetailData: Codable {
    let id: Int;
    let status: Int;
    let roomImg: String;
    let roomName: String;
    let points: Int;
    let createTime: String;
    let list: [SDDollLogDetailSettelementData]
}
struct SDDollLogDetailSettelementData: Codable {
    let id: Int;
    let dollLogId: Int;
    let memberId: Int;
    let machineId: Int;
    let localUrl: String;
    let points: Int;
    let machineType: Int;
    let updateTime: String;
    let createTime: String;
    let deleted: Int;
}
