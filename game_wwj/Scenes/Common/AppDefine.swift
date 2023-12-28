//
//  AppDefine.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/10.
//

import UIKit
import SwiftDate

class AppDefine: NSObject {
        
    static let TestURL = "http://192.168.0.115:8080/api/";
    static let ProURL = "https://tbwz.yyzyxt.cn/api/";
    
    static let tcp_address_pro = "121.36.196.87";
    static let tcp_port_pro = 58888; //56792
    
    static let tcp_address_test = "192.168.0.115";
    static let tcp_port_test = 58888;
    
    static let BaseURL = ProURL
    
    static let loginForDebug = false;
    //123.60.149.177  121.36.196.87      192.168.0.115
//    static let tcp_address = "123.60.149.177";
    static let tcp_address = tcp_address_pro
    //56792       58888
    static let tcp_port = tcp_port_pro
    
    static let KeyGameMusicOn = "game_music_on";
    
    static let gameAgreementHTMLURL = "http://tbwz.yyzyxt.cn/policy.html";
    static let userAgreementHTMLURL = "http://tbwz.yyzyxt.cn/user.html";
    
    static let channelKey = "tuibiwangzhe";
    static let openEncrypt = "on";
    static let requestUrlEncrypt = "on";
    
    static let submissionDate = "2022-12-15";
    
    static let PNSATAUTHSDKINFO = "0bO2p4apXcTXWv5Nmd0jNYk02jCGojIKMES2bGdkBaMZUOuCDf6U9EweyOSPGnHJpNLgQ1MEUlvkXk28Y7yN/jrteUtPZH2vzmbSVFEONvp7da9e3Wxz/Kw3LcXFieR+3sjzh/pQXNIHcpXy4HFJXsTk5T43GITmBJ2jhoiWILGpz3w24No24dWSdxlYLBcltF9LiWgIZZAA135LWwSWc19nTbExISJfGjmgjcshGMe+JODZg+ZCTUmOMYLqkBwzTFlehtuDdNQ=";
    
    static let PNSATAUTHSDKINFOKEY = "ATAuthSDKInfoKey";
    
    static let needDiamond = true;
    
    
    static var inReviewCheck: Bool {
        get {
            let rome = Region(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)
            let submissionDateInRegion = submissionDate.toDate("yyyy-MM-dd");
            guard submissionDateInRegion != nil else { return false};
            let releaseDateInRegion = submissionDateInRegion! + 5.days;
            let isBeforeDay = DateInRegion(region: rome).isBeforeDate(releaseDateInRegion, orEqual: true, granularity: .day);
            if isBeforeDay {
                return true;
            }
            return false;
        }
    }
    
    static var runBaseUrl: String {
        get {
            return BaseURL;
        }
    }
    static var runTcpAddress: String {
        get {
            return tcp_address;
        }
    }
}
