//
//  HomeAPIRouter.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/10.
//

import Alamofire

enum HomeAPIRouter: SDBaseRouter {
    
    var baseURLString: String {
        return AppDefine.runBaseUrl;
    }
    
    case getHomeRoomWithType(_ groupId: Int, _ page: Int)
    case getHomeRoomWithTag(_ type: Int);
    case getHomeBanner(_ position: Int)
    case enterMatchin(_ machineSn: String)
    case getHomeGroup
    case getGameStrategy
    case getGameRule(_ machineSn: String)
    
    var path: String {
        switch self {
        case .getHomeBanner(_): return "hkjtdmatiQkf9qhP4EK6yg==";
        case .getHomeRoomWithType(_, _): return "VZIz+fhMe5menWwAmRyaXA==";
        case .getHomeRoomWithTag(_): return "tXQkTeh42o2EzLb3Jq8dOg==";
        case .enterMatchin(_ ): return "qjkK/PCl/EvYTPXrN+ptjA==";
        case .getHomeGroup: return "/B5zkxH0h0VVjTmfDA/Rjg==";
        case .getGameStrategy:
            return "CY7sVXYRF1xi33COG7Jyag==";
        case .getGameRule(_): return "vytztbhJqbJuV/u4t5CJjw==";
        }
    }
    var method: HTTPMethod {
        switch self {
        case .enterMatchin(_): return HTTPMethod.post;
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
        case .getHomeRoomWithType(let groupId, let page): return ["groupId": groupId, "page": page, "size": 10];
        case .getHomeRoomWithTag(_): return ["type": 2, "page": 1, "size": 99];
        case .enterMatchin(let machineSn): return ["machineSn": machineSn];
        case .getHomeBanner(let position): return ["position": position];
        case .getGameStrategy: return ["categoryId": 0];
        case .getGameRule(let machineSn): return ["machineSn": machineSn];
        default: return [:];
        }
    }
}
