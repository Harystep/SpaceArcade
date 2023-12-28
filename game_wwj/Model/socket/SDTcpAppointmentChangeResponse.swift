//
//  SDTcpAppointmentChangeResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

struct SDTcpAppointmentChangeResponse: SDTcpResponse {
    var cmd: String
    let appointmentCount: Int;
}
