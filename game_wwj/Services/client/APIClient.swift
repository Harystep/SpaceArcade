//
//  APIClient.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import Alamofire
import CodableAlamofire
import RxSwift
import Foundation


protocol ClientType {
    func request<T: Codable>(_: URLRequestConvertible) -> Single<T>
}


class APIClient: ClientType {
    
    // MARK: - Properties
    private let sessionManager: SessionManager
    private let decoder: JSONDecoder
    private let queue = DispatchQueue(label: "com.sander.response-queue", qos: .userInitiated, attributes: [.concurrent])
    

    
    // MARK: - Lifecycle
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30  // seconds
        configuration.timeoutIntervalForResource = 30 // seconds
        sessionManager = Alamofire.SessionManager(configuration: configuration)

        // JSON Decoding
        decoder = JSONDecoder()
        //decoder.dateDecodingStrategy = .iso8601
    }
    
    
    func request<M: Codable>(_ endpoint: URLRequestConvertible) -> Single<M> {
        return Single<M>.create { [unowned self] single in
            let request = self.sessionManager.request(endpoint)
            request
                .validate(statusCode: 200..<600)
                .validate({ request, response, data in
                    guard request != nil else {return .success};
                    if let url = request?.url {
                        log.info("[HTTP] 请求 URL -> \(url)");
                    }
                    if let responseData = data {                        
                        log.info("[HTTP] 请求结果 -> \(String.init(data: responseData, encoding: .utf8)!)");
                    }
                    return .success;
                })
                .responseDecodableObject(queue: self.queue, decoder: self.decoder) { (response: DataResponse<M>) in
                    log.debug("[HTTP] response -> \(response.result)")
                    if response.data != nil {
                        let decoder = JSONDecoder()
                        do {
                            let openEncrypt:NSString = AppDefine.openEncrypt as NSString
                            if openEncrypt.isEqual("on") {
                                let person = try decoder.decode(M.self, from: YDAESDataTool.responseDecryptData(response.data!))
                                single(.success(person))
                            } else {
                                let person = try decoder.decode(M.self, from: response.data!)
                                single(.success(person))
                            }
                        } catch let err {
                            log.debug("[HTTP] response Failure -> \(err)")
                            single(.error(err))
                        }
                    }
//                    switch response.result {
//                    case let .success(val):
//                        single(.success(val))
//                    case let .failure(err):
//                        log.debug("[HTTP] response Failure -> \(err)")
//                        single(.error(err))
//                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func decodePerson() {
        let jsonStr = "{\"age\":16,\"isGoodGrades\":1,\"name\":\"XiaoMing\",\"height\":160.5}"
        guard let data = jsonStr.data(using: .utf8) else {
            print("get data fail")
            return
        }
        let decoder = JSONDecoder()
        do {
            let person = try decoder.decode(SDUser.self, from: data)
            print(person)
        } catch let err {
            print("err", err)
        }
    }

}
