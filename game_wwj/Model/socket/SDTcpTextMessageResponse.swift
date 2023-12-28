//
//  SDTcpTextMessageResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpTextMessageResponse: SDTcpResponse {
    var cmd: String
    let content: String;
    let sender: String;
}
