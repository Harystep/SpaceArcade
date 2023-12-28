//
//  SPExchangeGoldWithPointData.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit

struct SPExchangeGoldWithPointData: Codable {
    let points: Int;
    let list: [SPExchagneGoldData];
}
struct SPExchagneGoldData: Codable {
    let id: Int;
    let goldCoin: Int;
    let points: Int;
    let sort: Int;
    let createTime: String;
}
