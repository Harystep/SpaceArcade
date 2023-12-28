//
//  SDTcpHeartData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpHeartData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    init(cmd: String, vmc_no: String) {
        self.cmd = cmd
        self.vmc_no = vmc_no
    }
}
