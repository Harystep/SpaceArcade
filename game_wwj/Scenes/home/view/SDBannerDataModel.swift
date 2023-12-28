//
//  SDBannerDataModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/1.
//

import UIKit

class SDBannerDataModel: NSObject {
    let originData : SDBannerData;
    init(_ data: SDBannerData) {
        self.originData = data;
        super.init();
    }
}
