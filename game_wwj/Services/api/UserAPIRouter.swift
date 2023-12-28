//
//  UserAPIRouter.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/10.
//

import Alamofire

enum UserAPIRouter: SDBaseRouter {
    var baseURLString: String {
        return AppDefine.runBaseUrl;
    }
    
    case appleLogin(_ token: String)
    case fastLogin(_ token: String)
    case login(_ mobile: String, _ code: String)
    case getMobileCaptcha(_ mobile: String)
    case getMemberAgreement
    case getUserInfo
    case exchangeWelfareCode(_ code: String)
    case getDollLog(_ type: Int, _ page: Int, _ size: Int)
    case getDollSettleInfo(_ id: String);
    case dollSettleAppeal(_ id: String, _ reason: String);
    case getDollAppealLog(_ page: Int, _ size: Int);
    case getDollInfo(_ id: String);
    case getDollAppealInfo(_ id: String);
    case getDollMoneyList(_ source: Int, _ type: Int, _ page: Int);
    case getMemberGoodsPointList(_ type: Int, _ page: Int);
    case getDollMoneyForDiamondList(_ type: Int, _ page: Int);
    case cancelAccount
    
    case getSummaryRankForPoint(_ page: Int)
    case getSummaryRankForDiamond(_ page: Int)
    
    case getSignList
    case sendSign
    case invitCode(_ code: String)
    case sendAuthInfo(_ name: String, _ card: String)
    case updateUserInfo(_ nickName: String?, _ avatar: String?)
    
    var path: String {
        switch self {
        case .appleLogin(_): return "1AUcD0ADNjMh65o204jn2A==";
        case .login(_ , _ ): return "28igPsU9NbDHFmI6tjQdpQ==";
        case .getMemberAgreement: return "BeRENvGhwl2OxJs8BCaR3ElP2IdDYFvfqT8xjSKagSw=";
        case .getUserInfo: return "Sw0QYosX4vG7dHcDQnI7Wg==";
        case .getDollLog(_, _, _): return "ywUAF31FSMVFYxEER9piFw==";
        case .getDollSettleInfo(_): return "VNsvvGrQiA9s+cHfKncv+a5rfFxfVNLeeSBx74GtuXU=";
        case .exchangeWelfareCode(_):
            return "1bDU1v66+nDygy9gy9VIZbfCH0UXf5zSwXzArg+ZW6g=";
        case .dollSettleAppeal(_, _): return "4FH5N4VNcl2ZRuFF8xHCQy0V1xJKrUR/lI74tjxC+W0=";
        case .getDollAppealLog(_ , _): return "LaDNklTY5ckWXfkmuDwtXw==";
        case .cancelAccount: return "WQgHYYyv0it07uIFu/PFmIkpAlbXqom2H+a7L8DmqyM=";
        case .getMobileCaptcha(_):
            return "uoXJRm5NWUzldfpeqrY1jQ==";
        case .getDollInfo(_):
            return "icUnOQ/16WE3vCcSLU1xDQ==";
        case .getDollAppealInfo(_):
            return "Ye+U72Q+hoBotS5GwoKM5KsoELXnLfiy+XH1rcdTAls=";
        case .getDollMoneyList(_ ,_, _):
            return "Kwp/04uaqmUywiF7sS2Mk6qzGaQZahsqo5YYkFAi8V0=";
        case .getMemberGoodsPointList(_, _):
            return "PmsHPjCBoI581+bmDx2s8JipDTS9xXlc11ArrVzvhRU=";
        case .getDollMoneyForDiamondList(_, _):
            return "Ra8SlqAfjTXlPLNiNYbrwg==";
        case .getSummaryRankForPoint(_):
            return "dBlxPutUJAnxnQuYFcjrCC/RSXusGb2rRqnlb01twK0=";
        case .getSummaryRankForDiamond(_):
            return "h9Nvv8J/EBQbETtLdBBCt/3QdRImTxU7yYEUZoWTJXs=";
        case .getSignList:
            return "npG0cdqiF7/S1aisBdCLVQ==";
        case .sendSign:
            return "TtkFkuDBqiwZzabiQ3ugDQ==";
        case .invitCode(_):
            return "VNr9OlEkipJbMuIzNrcnWg==";
        case .sendAuthInfo(_, _):
            return "i2HumyB/gxy3OcM/XSZI3w==";
        case .updateUserInfo(_, _):
            return "+m/sQZE5sdgnjXZJqnY0qg==";
        case .fastLogin(_):
            return "9wor4sfXohLlA6V9/+E22egS7Zr/II2qrgYc7aawW04=";
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .appleLogin(_): return HTTPMethod.post;
        case .login(_ , _): return HTTPMethod.post;
        case .dollSettleAppeal(_ , _): return HTTPMethod.post;
        case .cancelAccount: return HTTPMethod.post;
        case .getMobileCaptcha(_): return HTTPMethod.post;
        case .sendSign: return HTTPMethod.post;
        case .invitCode(_): return HTTPMethod.post;
        case .sendAuthInfo(_, _): return HTTPMethod.post;
        case .updateUserInfo(_, _): return HTTPMethod.post;
        case .fastLogin(_ ): return HTTPMethod.post;
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
        case .appleLogin(let token): return ["identityToken": token];
        case .login(let moblie, let code): return ["mobile": moblie, "code": code, "platform": 3];
        case .getMobileCaptcha(let moblie): return ["mobile": moblie];
        case .exchangeWelfareCode(let code): return ["code": code];
        case .getDollLog(let type, let page, let size): return ["type": type, "page": page, "size": size];
        case .getDollSettleInfo(let id): return ["id": id];
        case .dollSettleAppeal(let id, let reason): return ["id": id, "reason": reason];
        case .getDollAppealLog(let page, let size): return ["page": page, "size": size];
        case .getDollInfo(let id): return ["id": id];
        case .getDollAppealInfo(let id): return ["id": id];
        case .getDollMoneyList(let source, let type, let page): return ["source": source, "type": type, "page": page, "pageSize": 10];
        case .getMemberGoodsPointList(let type, let page): return ["type": type, "page": page, "pageSize": 10];
        case .getDollMoneyForDiamondList(let type, let page): return ["type": type, "page": page, "pageSize": 10];
        case .getSummaryRankForPoint(let page): return ["page": page, "pageSize": 20];
        case .getSummaryRankForDiamond(let page): return ["page": page, "pageSize": 20];
        case .invitCode(let code): return ["code": code];
        case .sendAuthInfo(let name, let card): return ["name": name, "card": card];
        case .updateUserInfo(let nickName, let avatar): do {
            var inputMap: [String: String] = [String: String]();
            if nickName != nil {
                inputMap["nickname"] = nickName;
            }
            if avatar != nil {
                inputMap["avatar"] = avatar;
            }
            return inputMap;
        }
        case .fastLogin(let token): return ["loginToken": token];
        default: return [:];
        }
    }
}
