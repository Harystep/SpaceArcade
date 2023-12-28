//
//  SPExchangeCoordinator.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/27.
//

import UIKit
import RxCocoa
import RxSwift
class SPExchangeCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadHomeService & HadUserInfoServce & HadUserManager & HadRechargeService
    
    private let rootNavigation: UINavigationController
    private let dependencies: Dependencies
    
    init(rootNavigation: UINavigationController, dependencies: Dependencies) {
        self.rootNavigation = rootNavigation
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = SPExchangeViewController();

        self.rootNavigation.setViewControllers([viewController], animated: true);
    
        let avm : Attachable<SPExchangeViewModel> = .detached(self.dependencies);
        let viewModel = viewController.attach(wrapper: avm);
      
        return viewModel.toLoginTrgger.asObservable().take(1);
    }
}
