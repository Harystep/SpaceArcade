//
//  SDRechargeUnitCollectionData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit


class SDRechargeUnitCollectionData: SDCollectionViewModel {
    func getCellIdentifier() -> String {
        return "SDRechargeUnitCollectionViewCell"
    }
    let originData : SDChargeUnitData;
    let price: String;
    let money: String;
    init(originData: SDChargeUnitData) {
        self.originData = originData
        self.price = String.init(format: "%.2f", originData.price);
        self.money = String.init(format: "%.0f", originData.money);
    }
}
