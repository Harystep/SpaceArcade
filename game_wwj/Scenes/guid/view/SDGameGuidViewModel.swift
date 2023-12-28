//
//  SDGameGuidViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/23.
//

import UIKit

class SDGameGuidViewModel: SDTableViewModel {
    func getCellIdentifier() -> String {
        return "SDGameGuidTableViewCell";
    }
    let originData: SDGameStrategyData;
    let guidTitle: String;
    let guidUrl: String;
    let guidThumb: String;
    init(originData: SDGameStrategyData) {
        self.originData = originData
        self.guidTitle = originData.title;
        self.guidThumb = originData.thumb;
        self.guidUrl = originData.url;
    }
}
