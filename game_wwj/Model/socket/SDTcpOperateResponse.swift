//
//  SDTcpOperateResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/17.
//

import UIKit

struct SDTcpOperateResponse: SDTcpResponse {
    var cmd: String
    let status: Int;
    let msg: String;
    let position: Int;
    let goldCoin: Int?;
}
