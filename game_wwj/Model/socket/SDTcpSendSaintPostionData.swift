//
//  SDTcpSendSaintFireData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/21.
//

import UIKit

class SDTcpSendSaintPostionData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    let position: Int;
    
    init(cmd: String, position: Int) {
        self.cmd = cmd
        self.vmc_no = "";
        self.position = position
    }
}
