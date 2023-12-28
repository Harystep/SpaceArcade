//
//  SPExchangeGoldWithPointItemViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit

class SPExchangeGoldWithPointItemViewModel: SDCollectionViewModel {
    func getCellIdentifier() -> String {
        return "SPExchangeGoldWithPointItemCollectionViewCell";
    }
    let originData: SPExchagneGoldData;
    let valueGold: String;
    let valuePoint: String;
    init(originData: SPExchagneGoldData) {
        self.originData = originData
        self.valueGold = "\(self.originData.goldCoin)太空币";
        self.valuePoint = "\(self.originData.points)能量";
    }
}
