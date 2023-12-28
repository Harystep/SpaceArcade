//
//  SDBaseRouter.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/10.
//

import Alamofire

enum SDURLEncoding {
    case JSONEncoding
    case URLEncoding
}
protocol SDBaseRouter: URLRequestConvertible {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var requestEncoding: SDURLEncoding { get }
    var parameters: Parameters { get }
}

extension SDBaseRouter {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL();
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue;
        
        var requestParameters = parameters;
        
        if let accessToken = SDUserManager.token {
            requestParameters["accessToken"] = accessToken;
        }
        urlRequest.addValue(AppDefine.channelKey, forHTTPHeaderField: "channelKey")
        urlRequest.addValue(AppDefine.openEncrypt, forHTTPHeaderField: "responseEncrypt")
        urlRequest.addValue(AppDefine.requestUrlEncrypt, forHTTPHeaderField: "requestUrlEncrypt")
        
        switch requestEncoding {
        case .JSONEncoding:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: requestParameters);
        case .URLEncoding:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: requestParameters);
        }
        return urlRequest;
    }
}
