//
//  SDTcpOtherGrabResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpOtherGrabResponse: SDTcpResponse {
    var cmd: String
    let nickname: String?
    let value : Int;
}
