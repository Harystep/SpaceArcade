//
//  SDGameRoomData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/11.
//

import UIKit

struct SDGameRoomTagPageData: Codable {
    let total_records: Int;
    let data: [SDGameRoomData];
    let page: Int;
    let page_size: Int;
    let total_pages: Int;
}

struct SDGameRoomData: Codable {
    let roomId: Int;
    let roomName: String;
    let roomImg: String;
    let machineId: Int;
    let machineSn: String;
    let status: Int;
    let machineType: Int;
    let minLevel: Int;
    let minGold: Int;
    let multiple: Int;
    let costType: Int;
    let sort: Int;
    let cost: Int;
    let player: Int;
    let type: Int?
}
