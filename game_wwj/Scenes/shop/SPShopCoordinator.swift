//
//  SPShopCoordinator.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/27.
//

import UIKit
import RxCocoa
import RxSwift

class SPShopCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadHomeService & HadUserManager & HadCustomService & HadUserInfoServce & HadRechargeService
    
    private let rootNavigation: UINavigationController
    private let dependencies: Dependencies
    
    init(rootNavigation: UINavigationController, dependencies: Dependencies) {
        self.rootNavigation = rootNavigation
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = SDShopViewController();

        self.rootNavigation.setViewControllers([viewController], animated: true);
    
        let avm : Attachable<SDShopViewModel> = .detached(self.dependencies);
        let viewModel = viewController.attach(wrapper: avm);
        viewModel.chargePayAliPayResult.asObservable().subscribe(onNext: { [unowned self] payData in
            let viewController = SPPayWebViewController(payData);
            viewController.hidesBottomBarWhenPushed = true;
            self.rootNavigation.pushViewController(viewController, animated: true);
        }).disposed(by: disposeBag);
        return viewModel.toLoginTrigger.asObservable().take(1);
    }
}
