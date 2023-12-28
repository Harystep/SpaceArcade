//
//  SDSignListData.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit

struct SDSignListData: Codable {
    let list: [SDSignData];
    let status: Int;
}
struct SDSignData: Codable {
    let points: Int;
    let desc: String;
    let status: Int;
    let type: Int;
}
