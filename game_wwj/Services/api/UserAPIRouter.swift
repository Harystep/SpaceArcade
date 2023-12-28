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
        case .appleLogin(_): return "apple/login";
        case .login(_ , _ ): return "login";
        case .getMemberAgreement: return "member/agreement";
        case .getUserInfo: return "user/info/v2";
        case .getDollLog(_, _, _): return "doll/log";
        case .getDollSettleInfo(_): return "doll/settle/info";
        case .exchangeWelfareCode(_):
            return "welfareCode/exchange"
        case .dollSettleAppeal(_, _): return "doll/settle/appeal";
        case .getDollAppealLog(_ , _): return "doll/appeal/log";
        case .cancelAccount: return "member/cancelAccount";
        case .getMobileCaptcha(_):
            return "mobile/captcha"
        case .getDollInfo(_):
            return "doll/log/info"
        case .getDollAppealInfo(_):
            return "doll/appeal/info";
        case .getDollMoneyList(_ ,_, _):
            return "doll/money/source/list";
        case .getMemberGoodsPointList(_, _):
            return "memberGoods/pointList/v2"
        case .getDollMoneyForDiamondList(_, _):
            return "doll/money/list";
        case .getSummaryRankForPoint(_):
            return "summary/rank/point/v2";
        case .getSummaryRankForDiamond(_):
            return "summary/rank/diamond/v2";
        case .getSignList:
            return "signList/v2"
        case .sendSign:
            return "sign/v2"
        case .invitCode(_):
            return "invite/code"
        case .sendAuthInfo(_, _):
            return "user/name/auth"
        case .updateUserInfo(_, _):
            return "user/edit"
        case .fastLogin(_):
            return "user/aliyun/one_key_login"
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
