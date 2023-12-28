//
//  SDUserManager.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit

import RxSwift
import RxCocoa

import ProgressHUD

import SPIndicator;

enum AuthenticationState {
    case signedNot
    case signedIn
    case signedOut
}

class SDUserManager {
    
    static var token: String? = nil;
    
    var authenticationState: AuthenticationState;
    
    let currentUser = BehaviorSubject<SDUser?>(value: nil);
    
    private let client: ClientType
    
    let storageManager: SDUserStorageManagerType
    
    init() {
        self.client = APIClient();
        self.storageManager = SDUserStorageManager();      
        if let user = storageManager.read() {
            self.authenticationState = .signedIn;
            self.currentUser.onNext(user);
            if let accessToken = user.accessToken?.accessToken {
                let token:NSString = ZCSaveUserData.getUserToken() as NSString
                if token.length > 0 {                    
                    SDUserManager.token = accessToken;
                    ZCSaveUserData.saveUserToken(accessToken);
                }
            }
        } else {
            self.authenticationState = .signedNot;
        }
    }
    
    @objc func notiJumpLogoUIBackData(_ data:Notification) {
        
    }
}

protocol LoginService {
    func loginWithToken(token: String) -> Single<Bool>
    func login(mobile: String, code: String) -> Single<Bool>
    func loginWithError();
    func saveLocalUser(_ user: SDUser);
    func fastLoginWithToken(token: String) -> Single<Bool>
}
extension SDUserManager: LoginService {
       
    func saveLocalUser(_ user: SDUser) {
        if let localUser = try? self.currentUser.value() {//mobile: user.money
            let newLocalUser = SDUser(memberId: user.memberId, money: user.money, gender: user.gender, avatar: user.avatar, inviteCode: user.inviteCode, aliasId: user.aliasId, type: user.type, goldCoin: user.goldCoin, nickname: user.nickname, points: user.points, accessToken: localUser.accessToken, memberLevelDto: user.memberLevelDto,  isSign: user.isSign, account: user.account, authStatus: user.authStatus);
            self.storageManager.store(user: newLocalUser);
        }
    }
    func loginWithError() {
        self.authenticationState = .signedOut;
        self.currentUser.onNext(nil);
    }
    
    func login(mobile: String, code: String) -> Single<Bool> {
        return client.request(UserAPIRouter.login(mobile, code)).do(onSuccess: { [unowned self] (result: SDResponse<SDUser>) in
            log.debug("[HTTP] login -> \(result)");
            if result.getCode() == 0 && result.data != nil {
                self.authenticationState = .signedIn;
                self.currentUser.onNext(result.data!);
                if let accessToken = result.data!.accessToken?.accessToken {
                    ZCSaveUserData.saveUserToken(accessToken)
                    SDUserManager.token = accessToken;                    
                }
                storageManager.store(user: result.data!);
            } else {
                self.authenticationState = .signedOut;
//                ProgressHUD.showError(result.getMsg());
                SPIndicator.present(title: "警告", message: result.getMsg(), haptic: .error);

            }
        }).map { result in
            if result.errCode == 0 {
                return true;
            }
            return false;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)).observeOn(MainScheduler())
    }
    func fastLoginWithToken(token: String) -> RxSwift.Single<Bool> {
        return client.request(UserAPIRouter.fastLogin(token)).do(onSuccess: { [unowned self] (result: SDResponse<SDUser>) in
            log.debug("[HTTP] appleLogin -> \(result)");
            if result.errCode == 0 && result.data != nil {
                self.authenticationState = .signedIn;
                self.currentUser.onNext(result.data!);
                if let accessToken = result.data!.accessToken?.accessToken {
                    ZCSaveUserData.saveUserToken(accessToken)
                    SDUserManager.token = accessToken;
                }
                storageManager.store(user: result.data!);
            } else {
                SPIndicator.present(title: "警告", message: result.getMsg(), haptic: .error);
                self.authenticationState = .signedOut;
            }
        }).map { result in
            if result.errCode == 0 {
                return true;
            }
            return false;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)).observeOn(MainScheduler())
    }
    func loginWithToken(token: String) -> Single<Bool> {
        
        return client.request(UserAPIRouter.appleLogin(token)).do(onSuccess: { [unowned self] (result: SDResponse<SDUser>) in
            log.debug("[HTTP] appleLogin -> \(result)");
            if result.errCode == 0 && result.data != nil {
                self.authenticationState = .signedIn;
                self.currentUser.onNext(result.data!);
                if let accessToken = result.data!.accessToken?.accessToken {
                    ZCSaveUserData.saveUserToken(accessToken)
                    SDUserManager.token = accessToken;
                }
                storageManager.store(user: result.data!);
            } else {
                self.authenticationState = .signedOut;
                SPIndicator.present(title: "警告", message: result.getMsg(), haptic: .error);
            }
        }).map { result in
            if result.errCode == 0 {
                return true;
            }
            return false;
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    }
}

protocol LogoutService {
    func logout() -> Single<Bool>;
}
extension SDUserManager: LogoutService {
    func logout() -> RxSwift.Single<Bool> {
        return Single.just(true)
            .delay(.microseconds(500), scheduler: MainScheduler.instance)
            .do(onSuccess: { [weak self] _ in
                SDUserManager.token = nil;
                ZCSaveUserData.saveUserToken("")
                self?.authenticationState = .signedOut;
                self?.storageManager.clear();
                self?.currentUser.onNext(nil);
            })
    }
}

protocol SDUserStorageManagerType {
    func store(user: SDUser)
    func read() -> SDUser?
    func clear()
}

class SDUserStorageManager: SDUserStorageManagerType {
    
    private let encoder: JSONEncoder
    private let archiveURL : URL
    
    init() {
        encoder = JSONEncoder();
        archiveURL = SDUserStorageManager.getDocumentsURL().appendingPathComponent("user");
    }
    
    func store(user: SDUser) {
        do {
            let data = try encoder.encode(user);
            guard NSKeyedArchiver.archiveRootObject(data, toFile: archiveURL.path) else {
                fatalError("Could not store data to url")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func read() -> SDUser? {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? Data {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(SDUser.self, from: data)
                return user
            } catch {
//                fatalError(error.localizedDescription)
                self.clear();
                return nil;
            }
        } else {
            return nil
        }
    }
    
    func clear() {
        do {
            try FileManager.default.removeItem(at: archiveURL)
        } catch {
            fatalError("Could not delete data from url")
        }
    }
    
    private static func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            // should incorporate better error handling
            fatalError("Could not retrieve documents directory")
        }
    }
    
    
}
