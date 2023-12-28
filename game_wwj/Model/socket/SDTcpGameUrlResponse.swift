//
//  SDTcpGameUrlResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpGameUrlResponse: SDTcpResponse {
    var cmd: String
    
    let gameUrl: String?;
    let profileUrl: String?;
}
