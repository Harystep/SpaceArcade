//
//  SDDollLogPageData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/15.
//

import UIKit

struct SDDollLogPageData: Codable {
    let total: Int;
    let data: [SDDollLogData];
    let page: Int;
    let pageSize: Int;
    let totalPages: Int;
}

struct SDDollLogData: Codable {
    let status: Int;
    let id: Int;
    let createTime: String;
    let roomImg: String?
    let roomName: String?
    let img: String?
    let points: Int?;
    let type: Int;
}
