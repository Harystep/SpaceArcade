//
//  SDAppealDollPageData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/25.
//

import UIKit

struct SDAppealDollPageData: Codable {
    let total: Int;
    let page: Int;
    let pageSize: Int;
    let totalPages: Int;
    let data: [SDAppealDollItemData];
}
struct SDAppealDollItemData: Codable {
    let id: Int;
    let createTime: String;
    let appealStatus: Int?
    let roomImg: String?
    let roomName: String?
    let points: Int?;
    let status: Int;
    let type: Int;
    let appeal: SDAppealDollResultData?
}

struct SDAppealDollResultData: Codable {
    let reason: String;
    let status: Int;
}



