//
//  SDTcpConnectData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpConnectData: SDBaseTcpData {
    var cmd: String
    
    var vmc_no: String
    
    let token: String
    
    init(cmd: String, vmc_no: String, token: String) {
        self.cmd = cmd
        self.vmc_no = vmc_no
        self.token = token
    }
    
}
