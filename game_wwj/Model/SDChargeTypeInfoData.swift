//
//  SDChargeTypeInfoData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit

struct SDChargeTypeInfoData: Codable {
    let normal: [SDChargeUnitData];
    let first: SDChargeUnitData?
    let month: SDChargeUnitData?
    let week: SDChargeUnitData?
    let paySupport: [SDPaySupportData]
}
struct SDChargeUnitData: Codable {
    let id: Int;
    let price: Float;
    let money: Float;
    let desc: String;
    let mark: String;
    let type: Int?
    let title: String?
    let iosOption: String
    let dayMoney: Int?
    
    func getApplyPayProductId() -> String{
        return iosOption;
    }
}

struct SDPaySupportData: Codable {
    let payMode: Int;
    let title: String;
    let remark: String;
    let isCheck: Int;
}
