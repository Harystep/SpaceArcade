//
//  SDRankCoordinator.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/25.
//

import UIKit
import RxCocoa
import RxSwift

class SDRankCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadHomeService & HadUserManager & HadCustomService & HadUserInfoServce
    
    private let rootNavigation: UINavigationController
    private let dependencies: Dependencies
    
    init(rootNavigation: UINavigationController, dependencies: Dependencies) {
        self.rootNavigation = rootNavigation
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = SDRankViewController();

        self.rootNavigation.setViewControllers([viewController], animated: true);
    
        let avm : Attachable<SDRankViewModel> = .detached(self.dependencies);
        let viewModel = viewController.attach(wrapper: avm);
      
        return .never()
    }
}
