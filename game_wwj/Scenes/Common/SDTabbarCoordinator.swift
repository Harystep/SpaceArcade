//
//  SDTableCoordinator.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/9.
//

import UIKit
import RxSwift
import RxCocoa

class SDTabbarCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadClient & HadUserManager & HadHomeService & HadCustomService & HadUserInfoServce & HadRechargeService & HadTCPClientService
    
    private let window: UIWindow
    private let dependencies: Dependencies
    
    private let tabbarDelegate: SDTabbarViewDelegate;
    
    var rootTabBarController: UITabBarController?
    
    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
        self.tabbarDelegate = SDTabbarViewDelegate.init();
    }
    
    override func start() -> Observable<Void> {
  
        let homeNavController = UINavigationController.init();
        homeNavController.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "ico_tabbar_home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ico_tabbar_home_s")?.withRenderingMode(.alwaysOriginal))
        let myNavController = UINavigationController.init();
        myNavController.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "ico_tabbar_mine")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ico_tabbar_mine_s")?.withRenderingMode(.alwaysOriginal))
        let rankNavController = UINavigationController.init();
        rankNavController.tabBarItem = UITabBarItem(title: "排行榜", image: UIImage(named: "ico_tabbar_rank")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ico_tabbar_rank_s")?.withRenderingMode(.alwaysOriginal))
//        let exchangeNavController = UINavigationController.init();
//        exchangeNavController.tabBarItem = UITabBarItem(title: "兑换中心", image: UIImage(named: "ico_tabbar_exchange")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ico_tabbar_exchange_s")?.withRenderingMode(.alwaysOriginal));
//        let shopNavController = UINavigationController();
//        shopNavController.tabBarItem = UITabBarItem(title: "商城", image: UIImage(named: "ico_tabbar_shop")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ico_tabbar_shop_s")?.withRenderingMode(.alwaysOriginal));
        homeNavController.tabBarItem.tag = 2;
        myNavController.tabBarItem.tag = 4;
        rankNavController.tabBarItem.tag = 3;
//        exchangeNavController.tabBarItem.tag = 1;
//        shopNavController.tabBarItem.tag = 0;
        
        let tabViewController = SPTabbarViewController([homeNavController.tabBarItem, rankNavController.tabBarItem, myNavController.tabBarItem]);
//        let tabViewController = SPTabbarViewController([shopNavController.tabBarItem, exchangeNavController.tabBarItem, homeNavController.tabBarItem, rankNavController.tabBarItem, myNavController.tabBarItem]);
        tabViewController.delegate = self.tabbarDelegate;
        tabViewController.tabBar.backgroundColor = UIColor.white;
//        tabViewController.viewControllers = [shopNavController, exchangeNavController, homeNavController, rankNavController, myNavController];
        tabViewController.viewControllers = [homeNavController, rankNavController, myNavController];
        
        let spaceNavController = UINavigationController.init();
        let spaceVc = YDSpaceCenterController();
        spaceNavController.setViewControllers([spaceVc], animated: true);
        
        let homeObservable = self.configHome(navigation: homeNavController);
        let mineObservable = self.configMine(navigation: myNavController);
        let rankObservable = self.configRank(navgiation: rankNavController);
//        let exchangeObservable = self.configExchange(navigation: exchangeNavController);
//        let shopObservable = self.configShop(navigation: shopNavController)
        
        self.window.rootViewController = spaceNavController;
        self.window.makeKeyAndVisible();
        self.rootTabBarController = tabViewController;
        
        let toLoginTrigger = tabViewController.toLoginTrigger.asObserver().do { [unowned self] _ in
            dependencies.usermanager.authenticationState = .signedOut;
        }.asObservable();
        NotificationCenter.default.addObserver(self, selector: #selector(toBankTirgger(_:)), name: NSNotification.Name(rawValue: "topBankTrigger"), object: nil);
        //, exchangeObservable, shopObservable
        return Observable.merge(homeObservable, mineObservable, rankObservable, toLoginTrigger).take(1);
    }
}

private extension SDTabbarCoordinator {
    func configHome(navigation: UINavigationController) -> Observable<CoordinationResult> {
        let coordinator = SDHomeCoordinator(rootNavigation: navigation, dependencies: self.dependencies);
        return coordinate(to: coordinator);
    }
    func configMine(navigation: UINavigationController) -> Observable<CoordinationResult> {
        let coordinator = SDMineCoordinator(rootNavigation: navigation, dependencies: self.dependencies);
        return coordinate(to: coordinator);
    }
    func configRank(navgiation: UINavigationController) -> Observable<CoordinationResult> {
        let coordinator = SDRankCoordinator(rootNavigation: navgiation, dependencies: self.dependencies);
        return coordinate(to: coordinator);
    }
    func configShop(navigation: UINavigationController) -> Observable<CoordinationResult> {
        let coordinator = SPShopCoordinator(rootNavigation: navigation, dependencies: self.dependencies);
        return coordinate(to: coordinator);
    }
    func configExchange(navigation: UINavigationController) -> Observable<CoordinationResult> {
        let coordinator = SPExchangeCoordinator(rootNavigation: navigation, dependencies: self.dependencies);
        return coordinate(to: coordinator);
    }
    @objc func toBankTirgger(_ notification: Notification) {
        let info = notification.userInfo;
        if let type = notification.object as? SDBankType {
            switch type {
            case .bankForDiamond:
                self.rootTabBarController?.selectedIndex = 0;
                break;
            case .bankForGoldCoin:
                self.rootTabBarController?.selectedIndex = 0;
                break;
            case .bankForPoints:
                self.rootTabBarController?.selectedIndex = 1;
                break;
            default:
                break;
            }
        }
        
    }
    
//    func showLogin(controller: UIViewController) -> Observable<AuthenticationState> {
//        let coordinator = LoginCoordinator(navigation: controller, dependencies: self.dependencies);
//        return coordinate(to: coordinator);
//    }
}


