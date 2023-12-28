//
//  SDArcadeCoinResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpArcadeCoinResponse: SDTcpResponse {
    var cmd: String
    let status: Int;
    let msg: String;
    let leftCoin: Int?
}
