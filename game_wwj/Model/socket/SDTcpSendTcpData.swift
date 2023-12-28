//
//  SDTcpSendTcpData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/25.
//

import UIKit

class SDTcpSendTcpData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    init(cmd: String) {
        self.cmd = cmd
        self.vmc_no = "";
    }
}
