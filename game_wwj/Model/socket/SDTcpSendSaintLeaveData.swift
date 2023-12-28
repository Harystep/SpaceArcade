//
//  SDTcpSendSaintLeaveData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/25.
//

import UIKit

class SDTcpSendSaintLeaveData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    let isLeave: Int;
    
    let position: Int;

    init(isLeave: Int, position: Int) {
        self.cmd = "arcade_down";
        self.vmc_no = ""
        self.isLeave = isLeave
        self.position = position
    }
}
