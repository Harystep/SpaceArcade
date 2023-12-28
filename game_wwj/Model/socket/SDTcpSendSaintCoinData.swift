//
//  SDTcpSendSaintCoinData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/21.
//

import UIKit

class SDTcpSendSaintCoinData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    let position: Int;

    let isNewGame: Int;
    
    let multiple: Int;
    
    init(position: Int, isNewGame: Int) {
        self.cmd = SDTCPCMD.arcade_coin.rawValue;
        self.vmc_no = ""
        self.position = position
        self.isNewGame = isNewGame
        self.multiple = 1;
    }
    init(position: Int, isNewGame: Int, count: Int) {
        self.cmd = SDTCPCMD.arcade_coin.rawValue;
        self.vmc_no = ""
        self.position = position
        self.isNewGame = isNewGame
        self.multiple = count;
    }
}
