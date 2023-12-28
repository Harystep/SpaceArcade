//
//  SDGameStrategyData.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/22.
//

import UIKit

struct SDGameStrategyData: Codable {
    let id: Int;
    let title: String;
    let type: Int?;
    let tag: Int;
    let anthorId: Int;
    let status: Int;
    let thumb: String;
    let contentType: Int;
    let url: String;
    let authorName: String;
    let authorAvatar: String;
    let createTime: String;
}
