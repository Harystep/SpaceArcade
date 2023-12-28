//
//  SDRechargeAPIRouter.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit
import Alamofire;

enum SDRechargeAPIRouter: SDBaseRouter {
    var baseURLString: String {
        return AppDefine.runBaseUrl;
    }
    case chargeList(_ type: Int)
    case payChargeItemByApple(_ productId: String, _ receipt: String)
    case payChargeItemByAli(_ productId: String)
    case getExchangeGlodByPointList
    case exchangeMemberGold(_ num: Int)
    case pmExchangePoint(_ optionId: Int);
    case createAppleOrder(_ productId: String)

    var path: String {
        switch self {
        case .chargeList(_):
            return "/charge/list/channel/v2";
        case .payChargeItemByApple(_ , _ ): return "/charge/ios/pay/v3";
        case .payChargeItemByAli(_):
            return "/charge/ali/buy/v2"
        case .getExchangeGlodByPointList:
            return "/pm/option"
        case .exchangeMemberGold(_):
            return "/member/exchange/gold"
        case .pmExchangePoint(_):
            return "/pm/exchange/coin";
        case .createAppleOrder(_):
            return "charge/ios/create/order"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .payChargeItemByApple(_ , _ ): return HTTPMethod.post;
        case .payChargeItemByAli(_): return HTTPMethod.post;
        case .exchangeMemberGold(_ ): return HTTPMethod.post;
        case .pmExchangePoint(_): return HTTPMethod.post;
        case .createAppleOrder(_): return HTTPMethod.post;
        default: return HTTPMethod.get
        }
    }
    
    var requestEncoding: SDURLEncoding {
        switch self {
        default: return .URLEncoding
        }
    }
    
    var parameters: Alamofire.Parameters {
        switch self {
        case .chargeList(let type):
            return ["type": type];
        case .payChargeItemByApple(let productId, let receipt): return ["orderSn": productId, "receipt": receipt];
        case .payChargeItemByAli(let productId): return ["productId": productId];
        case .exchangeMemberGold(let num): return ["num": num];
        case .pmExchangePoint(let optionId): return ["optionId": optionId];
        case .createAppleOrder(let productId): return ["productId": productId];
        default: return [:];
        }
    }
}
