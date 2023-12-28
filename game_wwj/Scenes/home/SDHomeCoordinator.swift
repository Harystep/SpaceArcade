//
//  SDHomeCoordinator.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/25.
//

import RxCocoa
import RxSwift
import SPIndicator
import UIKit
import SDWebImage

class SDHomeCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadHomeService & HadUserManager & HadCustomService & HadUserInfoServce & HadTCPClientService & HadRechargeService & HadTCPClientService
    
    private var rootNavigation: UINavigationController
    private let dependencies: Dependencies
    
    init(rootNavigation: UINavigationController, dependencies: Dependencies) {
        self.rootNavigation = rootNavigation
        self.dependencies = dependencies
        
    }
    
    @objc func notiRankBackData(_ data:Notification) {
        print("---->come here")
        let rootNav:UINavigationController = data.object as! UINavigationController
//        self.rootNavigation = rootNav
        let viewControlelr = SDRankViewController()
        viewControlelr.modalPresentationStyle = .pageSheet
        viewControlelr.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        let avm: Attachable<SDRankViewModel> = .detached(self.dependencies)
        let viewModel = viewControlelr.attach(wrapper: avm)
        self.rootNavigation.present(viewControlelr, animated: true)
    }
    @objc func notiSignBackData(_ data:Notification) {
                
        let homeController = SDHomeViewController()
        let avm: Attachable<SDHomeViewModel> = .detached(self.dependencies)
        let viewModel = homeController.attach(wrapper: avm)
        
        viewModel.signData.asObservable().filter { data in
            data.status == 1
        }.flatMap { [unowned self] signData in
            self.showSignAlertController(signData.list, status: 1)
        }.flatMap { _ in
            self.dependencies.customService.sendSign()
        }.asObservable().subscribe(onError: { [weak self] _ in
//            log.debug("[签到] ---- 失败");
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                self?.showInputExchangeFail();
            }
        }).disposed(by: disposeBag)
        
        viewModel.showSignData.asObservable().flatMap { [unowned self] signData in
            self.showSignAlertController(signData.list, status: signData.status)
        }.flatMap { _ in
            self.dependencies.customService.sendSign().asDriverOnErrorJustComplete()
        }.asObservable().subscribe().disposed(by: disposeBag)
               
        viewModel.homeGroupTrigger.asObservable().subscribe(onNext: { item in
            self.showGamePageController(item.id)
        }).disposed(by: disposeBag)
        
        let guidLoginTrigger = viewModel.functionGuidTrigger.asObservable().flatMap { [unowned self] guidType in
            self.showGameGuid(guidType)
        }.do(onNext: { [unowned self] _ in
            self.dependencies.usermanager.authenticationState = .signedOut
        })
        
        let backData:SDSignListData = data.object as! SDSignListData;
        let viewController = SDSignViewController(backData.list, status: backData.status)
        viewController.modalPresentationStyle = .overCurrentContext
        self.rootNavigation.definesPresentationContext = true
        self.rootNavigation.providesPresentationContextTransitionStyle = true
        self.rootNavigation.present(viewController, animated: false)
        viewController.signAction.take(1)
        
        Observable.merge(viewModel.toLoginTrigger.asObservable(), guidLoginTrigger).take(1)
    }
    @objc func notiCancelOpBackData(_ data:Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kSelectGameTypeKey"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kJumpGameKey"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kRankListKey"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kSignResultKey"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kChangeNavKey"), object: nil)
    }
    
    
    @objc func notiChangeNavBackData(_ data:Notification) {
        let rootNav:UINavigationController = data.object as! UINavigationController
        self.rootNavigation = rootNav
        
        NotificationCenter.default.addObserver(self, selector: #selector(notiRankBackData(_:)), name: NSNotification.Name("kRankListKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiSignBackData(_:)), name: NSNotification.Name("kSignResultKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiSelectGameTypeBackData(_:)), name: NSNotification.Name("kSelectGameTypeKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiJumpGameTypeBackData(_:)), name: NSNotification.Name("kJumpGameKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiCancelOpBackData(_:)), name: NSNotification.Name("kJumpLogoUIKey"), object: nil)
    }
    //
    @objc func notiSelectGameTypeBackData(_ data:Notification) {
        let dic:NSDictionary = data.object as! NSDictionary
        let content:NSString = dic["id"] as! NSString
        let groupId:Int = Int(content.intValue)
        self.showGamePageController(groupId)
    }
    @objc func notiJumpGameTypeBackData(_ data:Notification) {
        let dic:NSDictionary = data.object as! NSDictionary
        let machineType:NSString = dic["machineType"] as! NSString
        let machineSn:String = dic["machineSn"] as! String
        let type:Int = Int(machineType.intValue)
        if (type == 4) {
            self.showGame(navigation: rootNavigation, machineSn: machineSn, machineType: type);
        } else if (type == 3) {
            self.showDollGame(navigation: rootNavigation, machineSn: machineSn, machineType: type)
        }
    }
    
    override func start() -> Observable<CoordinationResult> {
        
        NotificationCenter.default.addObserver(self, selector: #selector(notiChangeNavBackData(_:)), name: NSNotification.Name("kChangeNavKey"), object: nil)
        
        let viewController = SDHomeViewController()
        self.rootNavigation.setViewControllers([viewController], animated: true)
    
        let avm: Attachable<SDHomeViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        
        viewModel.signData.asObservable().filter { data in
            data.status == 1
        }.flatMap { [unowned self] signData in
            self.showSignAlertController(signData.list, status: 1)
        }.flatMap { _ in
            self.dependencies.customService.sendSign()            
        }.asObservable().subscribe(onError: { [weak self] _ in
//            log.debug("[签到] ---- 失败");
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                self?.showInputExchangeFail();
            }
        }).disposed(by: disposeBag)
        
        viewModel.showSignData.asObservable().flatMap { [unowned self] signData in
            self.showSignAlertController(signData.list, status: signData.status)
        }.flatMap { _ in
            self.dependencies.customService.sendSign().asDriverOnErrorJustComplete()
        }.asObservable().subscribe().disposed(by: disposeBag)
        
        viewModel.homeGroupTrigger.asObservable().subscribe(onNext: { item in
            self.showGamePageController(item.id)
        }).disposed(by: disposeBag)
        
        let guidLoginTrigger = viewModel.functionGuidTrigger.asObservable().flatMap { [unowned self] guidType in
            self.showGameGuid(guidType)
        }.do(onNext: { [unowned self] _ in
            self.dependencies.usermanager.authenticationState = .signedOut
        })
        
        return Observable.merge(viewModel.toLoginTrigger.asObservable(), guidLoginTrigger).take(1)
    }

    func showSignAlertController(_ list: [SDSignData], status: Int) -> Observable<Void> {
        let viewController = SDSignViewController(list, status: status)
        viewController.modalPresentationStyle = .overCurrentContext
        self.rootNavigation.definesPresentationContext = true
        self.rootNavigation.providesPresentationContextTransitionStyle = true
        self.rootNavigation.present(viewController, animated: false)
        return viewController.signAction.take(1)
    }
    
    func showGamePageController(_ item: Int) {
        let viewController = SDGamePageViewController(item)
        viewController.hidesBottomBarWhenPushed = true
        let avm: Attachable<SDGamePageViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        self.rootNavigation.pushViewController(viewController, animated: true)
//        viewModel.didSelectedItem.asObservable().flatMap { [unowned self] item in
//            return self.dependencies.homeService.enterMatchine(matchineSn: item.originData.machineSn)
//        }
        viewModel.didSelectedItem.asObservable().do(onNext: { [unowned self] liveRoom in
            if liveRoom.status == 2 {
                SPIndicator.present(title: "警告", message: "正在维护中", haptic: .error)
            }
        }).subscribe(onNext: { [unowned self] liveRoom in
            if liveRoom.status != 2 {
                if (liveRoom.type == 4) {
                    self.showGame(navigation: rootNavigation, machineSn: liveRoom.machineSn, machineType: liveRoom.type);
                } else if (liveRoom.type == 3) {
                    self.showDollGame(navigation: rootNavigation, machineSn: liveRoom.machineSn, machineType: liveRoom.type)
                }
            }
        }).disposed(by: disposeBag)
    }
   
    func showDollGame(navigation: UINavigationController, machineSn: String, machineType: Int) {
        ZCSaveUserData.saveUserToken(SDUserManager.token!)        
        let dollVc = HZPushGameController.init()
        // 8cfca02127b4
//        dollVc.machineSn = "8cfca0212839";
        dollVc.machineType = Int32(machineType)
        dollVc.machineSn = machineSn
        dollVc.token = SDUserManager.token!
        dollVc.addressUrl = AppDefine.tcp_address
        dollVc.port = Int32(AppDefine.tcp_port)
        dollVc.modalPresentationStyle = .fullScreen
        navigation.present(dollVc, animated: true)        
    }
    
    func showGame(navigation: UINavigationController, machineSn: String, machineType: Int) {
        print("machineType---->\(machineType)");
        let viewControlelr = SDArcadeGameViewController(machineSn: machineSn, machineType: machineType)
        viewControlelr.modalPresentationStyle = .fullScreen
        let avm: Attachable<SDGameViewModel> = .detached(self.dependencies)
        let viewModel = viewControlelr.attach(wrapper: avm)
        viewModel.viewWillDisappearTrigger.asObservable().subscribe().disposed(by: disposeBag)
            
        weak var rootViewController = viewControlelr
        
        Observable.merge(viewModel.onRechargeGameMoneyForCoinTrigger.asObservable(), self.getRechargeTrigger(viewModel.gameFuncTrigger)).flatMapLatest { _ in
            guard let rootViewController = rootViewController else { return Observable.just(false) }
            return self.showRechargeTypeAlertViewController(rootViewController: rootViewController).asObservable()
        }.subscribe(onNext: { _ in
            guard let rootViewController = rootViewController else { return }
            rootViewController.fetchUserInfoTrigger.onNext(())
        }).disposed(by: disposeBag);
        
        Observable.merge(viewModel.onRechargeGameMoneyForPointsTrigger.asObservable(), self.getExchangeTrigger(viewModel.gameFuncTrigger)).flatMapLatest { _ in
            guard let rootViewController = rootViewController else { return Observable.just(false) }
            return self.showExchangeAlertViewController(rootViewController: rootViewController).asObservable()
        }.subscribe(onNext: { _ in
            guard let rootViewController = rootViewController else { return }
            rootViewController.fetchUserInfoTrigger.onNext(())
        }).disposed(by: disposeBag);

        viewModel.getGameRuleTrigger.asObservable().subscribe(onNext: { [unowned self] rule in
            log.debug("[get rule ] ---> \(rule)")
            guard let rootViewController = rootViewController else { return }
            self.showGameRuleAlertViewController(rootViewController: rootViewController, rule: rule);
        }).disposed(by: disposeBag);
        
                    
        navigation.present(viewControlelr, animated: false)
    }
    
    func showGameRuleAlertViewController(rootViewController: UIViewController, rule: String) {
        let contentImageView = UIImageView();
        contentImageView.sd_setImage(with: URL(string: rule));
        let alert = SDGameAlertViewController.init(eventType: .alertForContentView, view: contentImageView);
        rootViewController.definesPresentationContext = true;
        alert.modalPresentationStyle = .overCurrentContext;
        alert.view.backgroundColor = UIColor.init(white: 0, alpha: 0.2);
        rootViewController.present(alert, animated: false);
    }

    func showRechargeTypeAlertViewController(rootViewController: UIViewController) -> Driver<Bool> {
        let viewControlelr = SDRechargeInGameAlertViewController(.rechargeForGold)
        viewControlelr.modalPresentationStyle = .overCurrentContext
        viewControlelr.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        let avm: Attachable<SDRechargeInGameAlertViewModel> = .detached(self.dependencies)
        let viewModel = viewControlelr.attach(wrapper: avm)
        rootViewController.present(viewControlelr, animated: true)
        return viewModel.chargePayResult
    }
    
    func showExchangeAlertViewController(rootViewController: UIViewController) -> Driver<Bool> {
        let viewContoller = SDExchangeInGameAlertViewController();
        viewContoller.modalPresentationStyle = .overCurrentContext
        viewContoller.view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        let avm: Attachable<SPExchangeViewModel> = .detached(self.dependencies)
        let viewModel = viewContoller.attach(wrapper: avm)
        rootViewController.present(viewContoller, animated: true)
        return viewModel.pmExchangePointResult
    }
    
    func showGameGuid(_ guidType: SDGameGuidType) -> Observable<Void> {
        if guidType == .GuidForInvite {
            if SDUserManager.token == nil {
                return Observable.just(())
            }
            self.goToInviteSharedViewController()
        } else if guidType == .GuidForKefu {
            if SDUserManager.token == nil {
                return Observable.just(())
            }
            self.goToKeFuViewController()
        } else if guidType == .GuidForNew {
            self.goToGuidViewController()
        }
        return .never()
    }

    private func goToInviteSharedViewController() {
        let viewController = SDInvitedCodeViewController()
        let avm: Attachable<SDInvitedCodeViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(viewController, animated: true)
    }

    private func goToGuidViewController() {
        let viewController = SDGuildViewController()
        let avm: Attachable<SDGuildViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(viewController, animated: true)
    }

    private func goToKeFuViewController() {
        
//    http://kefu.51sssd.com/chat/mobile?source=2&token=
        let kefuUrl = "http://kefu.51sssd.com/chat/mobile?source=2&token=\(SDUserManager.token!)"
        let webViewController = SDWebViewController(kefuUrl)
        webViewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(webViewController, animated: true)
    }
    
    private func getRechargeTrigger(_ gameFuncTrigger: Driver<SDFuncTag>) -> Observable<Void> {
        return gameFuncTrigger.filter { tag in
            return tag == .recharge_func;
        }.asObservable().mapToVoid();
    }
    
    private func getExchangeTrigger(_ gameFuncTrigger: Driver<SDFuncTag>) -> Observable<Void> {
        return gameFuncTrigger.filter { tag in
            return tag == .exchange_func;
        }.asObservable().mapToVoid();
    }
    private func getGameRuleTrigger(_ gameFuncTrigger: Driver<SDFuncTag>) -> Observable<Void> {
        return gameFuncTrigger.filter { tag in
            return tag == .rule_func;
        }.asObservable().mapToVoid();
    }
    
    func showInputExchangeFail() {
        let suerAlertViewController = SDSimpleResultAlertViewController("签到失败");
        suerAlertViewController.modalPresentationStyle = .overCurrentContext;
        self.rootNavigation.definesPresentationContext = true;
        self.rootNavigation.providesPresentationContextTransitionStyle = true;
        self.rootNavigation.present(suerAlertViewController, animated: false);
    }
}
