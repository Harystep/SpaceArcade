//
//  SDGameComplaintViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit

class SDGameComplaintViewModel: SDTableViewModel {
    func getCellIdentifier() -> String {
        return "SDGameComplaintTableViewCell";
    }
    let originData: SDAppealDollItemData;
    let imgUrl: String;
    let appealTitle: String;
    let appealTime: String;
    let appealStatusStr: String;
    let appealStatus : Int;
    
    init(originData: SDAppealDollItemData) {
        self.originData = originData
        if let roomImg = originData.roomImg {
            self.imgUrl = roomImg
        } else {
            self.imgUrl = "";
        }
        if let roomName = originData.roomName {
            self.appealTitle = roomName;
        } else {
            self.appealTitle = "";
        }
        self.appealTime = originData.createTime;
        self.appealStatus = originData.appealStatus!
        if originData.appealStatus == 0 {
            self.appealStatusStr = "申诉中"
        } else if originData.appealStatus == 1 {
            self.appealStatusStr = "申诉通过"

        } else if originData.appealStatus == 2 {
            self.appealStatusStr = "申诉拒绝"
        } else {
            self.appealStatusStr = "";
        }
    }
}
