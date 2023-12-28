//
//  SDTcpSystemResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpSystemResponse: SDTcpResponse {
    var cmd: String
    let content: String?
    let nickname: String?
}
