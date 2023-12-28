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
        case .getHomeBanner(_): return "banner/v1";
        case .getHomeRoomWithType(_, _): return "room/list";///room/groupRoom/list   //room/list
        case .getHomeRoomWithTag(_): return "home/tag";
        case .enterMatchin(_ ): return "enter/room";
        case .getHomeGroup: return "room/group/list";
        case .getGameStrategy:
            return "game/intro/list";
        case .getGameRule(_): return "game/rule"
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
