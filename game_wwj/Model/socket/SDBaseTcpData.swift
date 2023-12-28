//
//  SDBaseTcpData.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

enum SDTCPCMD: String {
    case hb = "hb"
    case conn = "conn"
    case start = "start"
    case grab = "grab"
    case text_message = "text_message"
    case leave = "leave"
    case move_direction = "move_direction"
    case stop = "stop"
    case push_coin = "push_coin"
    case wiper_start = "wiper_start"
    case push_coin_stop = "push_coin_stop"
    case operate = "operate"
    case arcade_coin = "arcade_coin"
    case fire_double = "fire_double"
    case arcade_move = "arcade_move"
    case arcade_stop = "arcade_stop"
    case single_move = "single_move"
    case fire = "fire"
    case fire_stop = "fire_stop"
    case fire_single = "fire_single"
    case settlement = "settlement"
    case arcade_down = "arcade_down"
    case sega_arcade_down = "sega_arcade_down"
    case sega_arcade_coin = "sega_arcade_coin"
    case sa_fire_double = "sa_fire_double"
    case sega_arcade_fire = "sega_arcade_fire"
    case sega_arcade_move = "sega_arcade_move"
    case sega_arcade_stop = "sega_arcade_stop"
    case sa_single_move = "sa_single_move"
    case sa_settlement = "sa_settlement"
    case sa_lock = "sa_lock"
    case sa_auto = "sa_auto"
    case appointment = "appointment"
}


protocol SDBaseTcpData: Codable {
    var cmd: String { get }
    var vmc_no: String { set get }
}

extension SDBaseTcpData {
    
    mutating func updateVmcNo(_ no: String) {
        vmc_no = no;
    }
    
    func getSendData() -> Data? {
        let data = try? JSONEncoder().encode(self);
        guard let jsonData = data else {return nil}
        guard let jsonStr = String.init(data: jsonData, encoding: .utf8) else {return nil}
        log.debug("[will send tcp data] ----> \(jsonStr)")
        let sendData = NSMutableData.init();
        let data1 = "doll".data(using: .utf8);
        var i = 4 + 4 + data!.count;
        let pointer = withUnsafePointer(to: &i) { UnsafeRawPointer($0) }
        let data2 = Data.init(bytes: pointer, count: 4);
        let s_data2 = self.dataWithReverse(srcData: data2);
        sendData.append(data1!);
        sendData.append(s_data2);
        sendData.append(data!);
        return sendData as Data;
    }
    
    func dataWithReverse(srcData: Data) -> Data {
        let byteCount = srcData.count;
        let dstData = NSMutableData(data: srcData);
        let halfLength = byteCount / 2;
        for i in 0..<halfLength {
            let begin = NSMakeRange(i, 1);
            let end = NSMakeRange(byteCount - i - 1, 1);
            let beginData = srcData.subdata(in: i ..< (i+1))
            let endData = srcData.subdata(in: (byteCount - i - 1) ..< (byteCount - i));
            dstData.replaceBytes(in: begin, withBytes: endData.unsafeRawPointer);
            dstData.replaceBytes(in: end, withBytes: beginData.unsafeRawPointer);
        }
        return dstData as Data;
    }
}
