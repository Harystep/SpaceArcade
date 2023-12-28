//
//  SDGameRoomItemViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit

class SDGameRoomItemViewModel: SDCollectionViewModel {
    func getCellIdentifier() -> String {
        return "SDGameRoomItemCollectionViewCell";
    }
    let originData: SDGameRoomData;
    init(_ data: SDGameRoomData) {
        self.originData = data;
    }
}
