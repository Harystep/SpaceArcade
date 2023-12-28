//
//  SDResponse.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/10.
//

import UIKit

struct SDResponse<DataType: Codable> : Codable {
    let errCode: Int?
    let errMsg: String?
    let code: Int?
    let msg: String?
    let data: DataType?
    
    func getCode() -> Int {
        if errCode != nil {
            return errCode!;
        }
        if code != nil {
            return code!;
        }
        return 500;
    }
    func getMsg() -> String? {
        if errMsg != nil {
            return errMsg;
        }
        if msg != nil {
            return msg;
        }
        return nil;
    }
}

struct SDEmptyResponse: Codable {
    let errCode: Int?
    let errMsg: String?
    let code: Int?
    let msg: String?
    let message: String?
    
    func getErrMsg() -> String {
        if errMsg != nil {
            return errMsg!;
        }
        if msg != nil {
            return msg!;
        }
        if (message != nil) {
            return message!;
        }
        return "";
    }
    
    func getCode() -> Int {
        if errCode != nil {
            return errCode!;
        }
        if code != nil {
            return code!;
        }
        return 500;
    }
}
