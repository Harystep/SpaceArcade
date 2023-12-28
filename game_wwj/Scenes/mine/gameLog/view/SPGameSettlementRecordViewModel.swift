//
//  SPGameSettlementRecordViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit

import SwiftyFitsize

class SPGameSettlementRecordViewModel: SDTableViewModel {
    func getCellIdentifier() -> String {
        return "SPGameSettlementRecordTableViewCell";
    }
    
    let originData: SDDollLogDetailSettelementData;
    let settelementImageUrl: String;
    let settelementResult: NSAttributedString;
    let settelementTime: String;
    
    
    init(originData: SDDollLogDetailSettelementData) {
        self.originData = originData
        self.settelementImageUrl = originData.localUrl;
        self.settelementTime = originData.createTime;
        
        
        let normalAttributed = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28)~, NSAttributedString.Key.foregroundColor: UIColor.white];
        let priceAttributed = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28~), NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#EEAA29")];
        let result = NSMutableAttributedString(attributedString: NSAttributedString(string: "结算结果：", attributes: normalAttributed));
        result.append(NSAttributedString(string: "\(originData.points)", attributes: priceAttributed));
        result.append(NSAttributedString(string: "能量", attributes: normalAttributed));
        
        self.settelementResult = result.copy() as! NSAttributedString;
        
    }
}
