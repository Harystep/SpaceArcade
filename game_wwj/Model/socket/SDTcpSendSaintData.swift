//
//  SDTcpSendSaintData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/18.
//

import UIKit

struct SDTcpSendSaintData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    let position: Int;
    
    let multiple: Int;
    
    init(position: Int) {
        self.cmd = SDTCPCMD.operate.rawValue;
        self.vmc_no = ""
        self.position = position
        self.multiple = 1;
    }
}
