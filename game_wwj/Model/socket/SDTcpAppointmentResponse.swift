//
//  SDTcpAppointmentResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpAppointmentResponse: SDTcpResponse {
    var cmd: String
    let status: Int;
    let type: Int;
}
