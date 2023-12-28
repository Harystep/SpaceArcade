//
//  SDGameLiveRoomData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDGameLiveRoomData: Codable {
    let imgs: [String]?;
    let liveRoom1: String?;
    let liveRoom2: String?;
    let machineId: String;
    let machineSn: String;
    let name: String?
    let num: Int;
    let price: String;
    let status: Int;
    let winImg: String?
    let type: Int;
    let gameUrl: String?;
    let profileUrl: String?;
    let size: Int?
    let cameraA: Int;
    let cameraB: Int;
    let machineType: Int?
    let positions: [Int];
}
