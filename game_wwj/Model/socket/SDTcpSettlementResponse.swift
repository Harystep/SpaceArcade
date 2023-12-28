//
//  SDTcpSettlementResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpSettlementResponse: SDTcpResponse {
    var cmd: String
    let points: Int;
    let status: Int;
    let msg: String;
}
