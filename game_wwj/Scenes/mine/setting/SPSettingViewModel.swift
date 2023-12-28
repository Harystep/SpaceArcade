//
//  SPSettingViewModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/7.
//

import UIKit
import RxSwift
import RxCocoa

class SPSettingViewModel: ViewModelType {
    typealias Dependency = HadUserManager;
    
    let settingList : Driver<[SPMineCellModel]>
    let logout: Driver<Void>
    let didSelectedSettingItem : Driver<SPMineCellModel>

    required init(dependency: Dependency, bindings: Bindings) {
        settingList = Observable.just([SPMineCellModel.init(.userAgreement), SPMineCellModel(.privacyAgreement), SPMineCellModel(.deleteAccount), SPMineCellModel(.signOut)]).asDriverOnErrorJustComplete()
        didSelectedSettingItem =  Driver.combineLatest(bindings.didSelectedCellIndexPath, settingList) { (selectedItem, list) -> (IndexPath, [SPMineCellModel]) in
            return (selectedItem, list)
        }.map { (indexPath, list) in
            return list[indexPath.row];
        }
        logout = didSelectedSettingItem.filter({ model in
            return model.cellType == .signOut
        }).flatMap { _ -> Driver<Bool> in
            return dependency.usermanager.logout().asDriverOnErrorJustComplete()
        }.asObservable().mapToVoid().asDriverOnErrorJustComplete();
    }
    struct Bindings {
        let fetchTrigger: Driver<Void>
        let didSelectedCellIndexPath: Driver<IndexPath>
    }
}
