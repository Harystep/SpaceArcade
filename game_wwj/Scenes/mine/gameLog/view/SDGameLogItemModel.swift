//
//  SDGameLogItemModel.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/14.
//

import UIKit

import SwiftyFitsize

class SDGameLogItemModel: SDTableViewModel {
    func getCellIdentifier() -> String {
        return "SDGameLogItemTableViewCell";
    }
    let originData: SDDollLogData;
    let imgUrl: String;
    let logTitle: String;
    let logTime: String;
    let logResult: NSAttributedString;
    
    init(originData: SDDollLogData) {
        self.originData = originData
        if let roomImg = originData.roomImg {
            self.imgUrl = roomImg
        } else {
            self.imgUrl = "";
        }
        if let roomName = originData.roomName {
            self.logTitle = roomName;
        } else {
            self.logTitle = "";
        }
        self.logTime = originData.createTime;
        let normalAttributed = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)~, NSAttributedString.Key.foregroundColor: UIColor.white];
        let priceAttributed = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28~), NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#EEAA29")];
        
        if originData.type == 1 {
            let result = NSMutableAttributedString(attributedString: NSAttributedString(string: "抓取结果：", attributes: normalAttributed));
            result.append(NSAttributedString(string: "\(originData.status == 0 ? "抓取成功" : "抓取失败")", attributes: priceAttributed));
            self.logResult = result.copy() as! NSAttributedString;
        } else {
            let result = NSMutableAttributedString(attributedString: NSAttributedString(string: "结算结果：", attributes: normalAttributed));
            result.append(NSAttributedString(string: "\(originData.points!)", attributes: priceAttributed));
            result.append(NSAttributedString(string: "能量", attributes: normalAttributed));
            
            self.logResult = result.copy() as! NSAttributedString;
        }
    }
    
    init(_ data: SDAppealDollItemData) {
        self.originData = SDDollLogData(status: data.status, id: data.id, createTime: data.createTime, roomImg: data.roomImg, roomName: data.roomName, img: data.roomImg, points: data.points, type: data.type);
        self.imgUrl = data.roomImg!;
        self.logTitle = data.roomName!;
        self.logTime = data.createTime;
        let normalAttributed = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)~, NSAttributedString.Key.foregroundColor: UIColor.white];
        let priceAttributed = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28~), NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#EEAA29")];
        
        if originData.type == 1 {
            let result = NSMutableAttributedString(attributedString: NSAttributedString(string: "抓取结果：", attributes: normalAttributed));
            result.append(NSAttributedString(string: "\(originData.status == 0 ? "抓取成功" : "抓取失败")", attributes: priceAttributed));
            self.logResult = result.copy() as! NSAttributedString;
        } else {
            let result = NSMutableAttributedString(attributedString: NSAttributedString(string: "结算结果：", attributes: normalAttributed));
            result.append(NSAttributedString(string: "\(originData.points!)", attributes: priceAttributed));
            result.append(NSAttributedString(string: "能量", attributes: normalAttributed));
            
            self.logResult = result.copy() as! NSAttributedString;
        }
    }
}
