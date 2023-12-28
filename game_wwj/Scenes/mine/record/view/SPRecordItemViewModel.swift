//
//  SPRecordItemViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit

class SPRecordItemViewModel: SDTableViewModel {
    func getCellIdentifier() -> String {
        return "SPRecordItemTableViewCell"
    }
    let name: String;
    let time: String;
    let value: String;
    let originData: SDMemberMoneyLogData;
    init(_ data: SDMemberMoneyLogData) {
        self.originData = data;
        self.name = self.originData.remark
        self.time = self.originData.createTime;
        self.value = String.init(format: "%.0f", self.originData.money);
    }
}
