//
//  SPSettingCoordinator.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/7.
//

import UIKit
import RxCocoa
import RxSwift

class SPSettingCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadUserManager;
    
    private let rootNavigation: UINavigationController
    private let dependencies: Dependencies
    
    init(rootNavigation: UINavigationController, dependencies: Dependencies) {
        self.rootNavigation = rootNavigation
        self.dependencies = dependencies
    }
    override func start() -> Observable<Void> {
        let viewController = SPSettingViewController();    
        let avm : Attachable<SPSettingViewModel> = .detached(self.dependencies);
        let viewModel = viewController.attach(wrapper: avm);
        viewController.hidesBottomBarWhenPushed = true;
        self.rootNavigation.pushViewController(viewController, animated: true);
        
        viewModel.didSelectedSettingItem.asObservable().subscribe(onNext: {
            [weak self] model in
            guard let self = self else { return }
            if model.cellType == .privacyAgreement {
                self.pushIntoAgreement(AppDefine.gameAgreementHTMLURL);
            } else if model.cellType == .userAgreement {
                self.pushIntoAgreement(AppDefine.userAgreementHTMLURL);
            }
            else if model.cellType == .signOut {
                NotificationCenter.default.post(name: NSNotification.Name("kJumpLogoUIKey"), object: nil)
            } else if model.cellType == .deleteAccount {
                NotificationCenter.default.post(name: NSNotification.Name("kDeleteAccountKey"), object: nil)
            }
            
        }).disposed(by: disposeBag);
        
        return viewModel.logout.asObservable();
    }
    
    func pushIntoAgreement(_ url: String) {
        let viewController = SDWebViewController(url);
        self.rootNavigation.pushViewController(viewController, animated: true);
    }
}
