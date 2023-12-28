//
//  SDSummaryRankPageData.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit

struct SDSummaryRankPageData: Codable {
//    let total: Int;
    let list: [SDSummaryRankData];
    let my: SDSummaryRankData;
//    let page: Int;
//    let pageSize: Int;
//    let totalPages: Int;
}
struct SDSummaryRankData: Codable {
    let memberId: Int;
    let nickName: String;
    let avatar: String;
    let total: Int;
    let rank: Int;
}
