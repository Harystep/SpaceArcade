//
//  SPRechargeItemViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/14.
//

import UIKit


enum SPChargeType {
    case chargeForNormal
    case chargeForWeek
    case chargeForMonth
    case chargeForFirst
}
enum SPChargeSectionType{
    case sectionForCard
    case sectionForNormal
}

enum SPPaySupportType {
    case aliPay
    case applePay
}

class SPRechargeItemViewModel: SDCollectionViewModel {
    func getCellIdentifier() -> String {
        return "SPRechargeItemCollectionViewCell"
    }
    let originData: SDChargeUnitData;
    let chargeType: SPChargeType;
    let paySupportList: [SPPaySupportType]
    init(originData: SDChargeUnitData, type: SPChargeType, payList: [SPPaySupportType]) {
        self.originData = originData
        self.chargeType = type;
        self.paySupportList = payList;
    }
}

struct SPRechargeSectionData {
    let sectionType: SPChargeSectionType
    let list: [SPRechargeItemViewModel];
}
