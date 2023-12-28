//
//  SDMemberMoneyLogData.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit

struct SDMemberMoneyLogPageData: Codable {
    let total: Int;
    let data: [SDMemberMoneyLogData];
    let page: Int;
    let pageSize: Int;
    let totalPages: Int;
}
struct SDMemberMoneyLogData: Codable {
    let money: Float;
    let type: Int;
    let source: Int;
    let remark: String;
    let createTime: String;
}

