//
//  SDTcpSendSaintMoveDirctionData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/21.
//

import UIKit

class SDTcpSendSaintMoveDirctionData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    let position: Int;

    let direction: Int;
    
    init(position: Int, direction: Int) {
        self.cmd = SDTCPCMD.single_move.rawValue;
        self.vmc_no = ""
        self.position = position
        self.direction = direction
    }
}
