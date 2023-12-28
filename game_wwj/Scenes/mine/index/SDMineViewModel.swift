//
//  SDMineViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/25.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import Photos

class SDMineViewModel: ViewModelType {
    typealias Dependency = HadHomeService & HadUserManager & HadUserInfoServce

    let currentUser: Driver<SDUser>
    
    let localCurrentUser: Driver<SDUser?>

    let mineSettingList: Driver<[SPMineCellModel]>
    let tapAvatarTrigger: Driver<Void>
    let tapInputNameTrigger: Driver<String>
    let didSelectedSettingItem : Driver<SPMineCellModel>
    let updateImageRequestResult: PublishSubject<String> = PublishSubject();
    let toLoginTrigger: Driver<Void>

    required init(dependency: Dependency, bindings: Bindings) {
        
        mineSettingList = Observable.just([SPAuthenticationMineCellModel.init(), SPMineCellModel(.seatGameLog), SPMineCellModel(.wawajGameLog), SPMineCellModel(.myAppeal), SPMineCellModel(.consumptionRecord), SPMineCellModel(.invitedShared), SPMineCellModel(.setting)]).asDriverOnErrorJustComplete();
        
        didSelectedSettingItem =  Driver.combineLatest(bindings.didSelectedCellIndexPath, mineSettingList) { (selectedItem, list) -> (IndexPath, [SPMineCellModel]) in
            return (selectedItem, list)
        }.map { (indexPath, list) in
            if(indexPath.row == 6) {
                NotificationCenter.default.post(name: NSNotification.Name("kJumpMineSettingKey"), object: nil)
            }
            return list[indexPath.row];
        }
        
        let fetchUserInfo = bindings.fetchTrigger.asObservable().flatMapLatest { _ in
            return dependency.userInfoService.getUserInfo()
        }.filter({ user in
            return user != nil;
        }).map({ user -> SDUser in
            return user!;
        }).do(onNext: { user in
            dependency.usermanager.saveLocalUser(user);
        }).asDriverOnErrorJustComplete();
        
        let localUserInfo = dependency.usermanager.currentUser.filter({ user in
            return user != nil;
        }).map({ user -> SDUser in
            return user!;
        }).asDriverOnErrorJustComplete();
        
        
        self.localCurrentUser = dependency.usermanager.currentUser.asDriverOnErrorJustComplete();
        
        self.currentUser = Observable.merge(fetchUserInfo.asObservable(), localUserInfo.asObservable()).asDriverOnErrorJustComplete();
        
        self.tapAvatarTrigger = bindings.tapAvatarTrigger.filter({ _ in
            return SDUserManager.token != nil;
        });
        self.tapInputNameTrigger = bindings.tapInputNameTrigger.filter({ _ in
            return SDUserManager.token != nil;
        }).withLatestFrom(self.currentUser).map({ user in
            return user.nickname;
        })
        self.toLoginTrigger = bindings.toLoginTrigger.do(onNext: { _ in
            dependency.usermanager.authenticationState = .signedOut
        })
    }
    
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let didSelectedCellIndexPath: Driver<IndexPath>
        let tapAvatarTrigger: Driver<Void>
        let tapInputNameTrigger: Driver<Void>
        let uploadImageFilterTrigger: Driver<UIImage>
        let toLoginTrigger: Driver<Void>

    }
    
    func uploadImage(img: UIImage){
        
        self.uploadFile { formData in
            let imgData = img.jpegData(compressionQuality: 0.5);
            formData.append(imgData!, withName: "image", fileName: "image_.png", mimeType: "image/png");
        }
    }
    
    func uploadFile(superFormDataHandler: @escaping (MultipartFormData) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": SDUserManager.token!
        ]
        let url = AppDefine.runBaseUrl + "upload/image";
        Alamofire.upload(multipartFormData: { forData in
            superFormDataHandler(forData);
        }, to: URL.init(string: url)!, headers: headers, encodingCompletion: { result in
            switch result {
            case let .success(upload, _, _):
                upload.uploadProgress(closure: { progress in
                }).responseJSON { response in
                    guard response.result.isSuccess else {
                                            /// 网络链接错误或者服务器故障
                                            return
                                        }
                    do {
                        let result = response.result.value as! NSDictionary;
                        if let code = result.object(forKey: "errCode") as? NSNumber {
                            if code == 0 {
                                 if let data = result.object(forKey: "data") as? String {
                                     self.updateImageRequestResult.onNext(data);
                                }
                            }
                        }
                        log.debug("[upload image] result -> \(result)")
                    } catch {
                        log.debug("[start upload image ] error ---> \(error) ")
                        
                    }
                }
            case let .failure(err):
                log.debug("请求失败 ----> \(err)")
            }
        });
    }
    
}
