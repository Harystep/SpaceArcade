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
            return "TuBvs5DJJnsFN+xTYynT0Iz8lxgDkZ1blso/l2YK2BI=";
        case .payChargeItemByApple(_ , _ ): return "qLbZIKfi/mGg/zvZDOvdD69b/zhDotbt2bgOPuKZh98=";
        case .payChargeItemByAli(_):
            return "mhc3ZrK2fNJeVSnafDaDgPj0mN9BQ5CGpgEh36a+jho=";
        case .getExchangeGlodByPointList:
            return "9H8KLnSLz/ocbNwd8iO8hg==";
        case .exchangeMemberGold(_):
            return "ABB4piK3ndB33Sr8Aan8FP4Hobunqwr89dusnA5OEV4=";
        case .pmExchangePoint(_):
            return "Cst1vvUnTpbE9A8rpnHP7fjDclCjKJAA/AwdT4g41CM=";
        case .createAppleOrder(_):
            return "eMedQduoldxdiYgVcqHud4FapkrTJekfzIuSxPaMbL0=";
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
