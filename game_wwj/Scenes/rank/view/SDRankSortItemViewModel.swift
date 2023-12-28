//
//  SDRankSortItemViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit

class SDRankSortItemViewModel: SDTableViewModel {
    func getCellIdentifier() -> String {
        return "SDRankSortItemTableViewCell";
    }
    
    let originData: SDSummaryRankData;
    let rankSort: String;
    let avatar: String;
    let nickName: String;
    let rankValue: String;
    let rankType: SDRankType;
    let rankTypeString: String;
    init(originData: SDSummaryRankData, type: SDRankType) {
        self.originData = originData
        self.rankType = type;
        self.rankSort = "\(self.originData.rank)"
        self.avatar = self.originData.avatar;
        self.nickName = self.originData.nickName;
        if self.originData.total > 1000 {
            let valuePres = self.originData.total % 1000;
            if valuePres > 0 {
                self.rankValue = String.init(format: "%.2fK", Float(self.originData.total) * 1.0 / 1000)
            } else {
                self.rankValue = String.init(format: "%.2fK", Float(self.originData.total) / 1000)
            }
        } else if self.originData.total > 1000000 {
            let valuePres = self.originData.total % 10000;
            if valuePres > 0 {
                self.rankValue = String.init(format: "%.2fW", Float(self.originData.total) * 1.0 / 10000)
            } else {
                self.rankValue = String.init(format: "%.2fW", Float(self.originData.total) / 10000)
            }
        }  else  {
            self.rankValue = "\(self.originData.total)";
        }
        if self.rankType == .sortKind {
            self.rankTypeString = "王者能量";
        } else {
            self.rankTypeString = "大亨值";
        }
    }
}
