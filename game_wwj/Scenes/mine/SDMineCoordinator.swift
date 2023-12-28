//
//  SDMineCoordinator.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/25.
//

import RxCocoa
import RxSwift
import UIKit
import ZLPhotoBrowser

class SDMineCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadHomeService & HadUserManager & HadCustomService & HadUserInfoServce
    
    private var rootNavigation: UINavigationController
    private let dependencies: Dependencies
    
    init(rootNavigation: UINavigationController, dependencies: Dependencies) {
        self.rootNavigation = rootNavigation
        self.dependencies = dependencies
    }
    
    @objc func notiChangeNavBackData(_ data:Notification) {
        let rootNav:UINavigationController = data.object as! UINavigationController
        self.rootNavigation = rootNav
        NotificationCenter.default.addObserver(self, selector: #selector(notiJumpMineTypeBackData(_:)), name: NSNotification.Name("kJumpMineKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiJumpSettingBackData(_:)), name: NSNotification.Name("kJumpMineSettingKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notiCancelOpBackData(_:)), name: NSNotification.Name("kJumpLogoUIKey"), object: nil)
    }
    
    @objc func notiJumpMineTypeBackData(_ data:Notification) {
        let viewController = SDMineViewController()
        let avm: Attachable<SDMineViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        self.rootNavigation.pushViewController(viewController, animated: true)
        
        let toNextDidSelectedSettingItem = viewModel.didSelectedSettingItem.filter { _ in
            SDUserManager.token != nil
        }
        weak var weakViewController = viewController
        toNextDidSelectedSettingItem.filter { model in
            model.cellType == .authentication
        }.asObservable().mapToVoid().withLatestFrom(viewModel.currentUser).filter { user in
            user.authStatus == 0
        }.flatMap { [unowned self] _ in
            self.showAuthentication(self.rootNavigation)
        }.subscribe(onNext: { _ in
            guard let strongViewController = weakViewController else { return }
            strongViewController.requestFetchTrigger.onNext(())
        }).disposed(by: disposeBag)
        
        toNextDidSelectedSettingItem.filter { model in
            model.cellType != .authentication
        }.asObservable().subscribe(onNext: { model in
            self.showNextPageViewController(self.rootNavigation, type: model.cellType)
        }).disposed(by: disposeBag)
        
        let logout = toNextDidSelectedSettingItem.filter { model in
            model.cellType == .setting
        }.asObservable().mapToVoid().flatMap { [unowned self] _ in
            self.goSettingPage(self.rootNavigation)
        }
        
        let toLoginTrigger = viewModel.didSelectedSettingItem.filter { _ in
            SDUserManager.token == nil
        }.do(onNext: { [unowned self] _ in
            self.dependencies.usermanager.authenticationState = .signedOut
        }).asObservable().mapToVoid()
        
        viewModel.tapInputNameTrigger.asObservable().flatMap { [unowned self] nickName in
            self.showInputNameViewController(self.rootNavigation, nickName)
        }.flatMap { [unowned self] newNickName in
            self.dependencies.userInfoService.updateUserInfo(nickName: newNickName, avatar: nil)
        }.subscribe(onNext: { _ in
            guard let strongViewController = weakViewController else { return }
            strongViewController.requestFetchTrigger.onNext(())
        }).disposed(by: disposeBag)
        
        viewModel.tapAvatarTrigger.asObservable().subscribe(onNext: { [unowned self] _ in
            guard let strongViewController = weakViewController else { return }
            self.showPhotoPreviewSheet(strongViewController);
        }).disposed(by: disposeBag)
        
        viewModel.updateImageRequestResult.flatMap { [unowned self]  imageUrl in
            return self.dependencies.userInfoService.updateUserInfo(nickName: nil, avatar: imageUrl);
        }.subscribe(onNext: { _ in
            guard let strongViewController = weakViewController else { return }
            strongViewController.requestFetchTrigger.onNext(())
        }).disposed(by: disposeBag)
        
        Observable.merge(logout, toLoginTrigger, viewModel.toLoginTrigger.asObservable())
    }
    
    @objc func notiJumpSettingBackData(_ data:Notification) {
        self.goSettingPage(self.rootNavigation)
    }
    @objc func notiCancelOpBackData(_ data:Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kJumpMineKey"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kJumpMineSettingKey"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kChangeNavKey"), object: nil)
    }
    override func start() -> Observable<CoordinationResult> {
        
        NotificationCenter.default.addObserver(self, selector: #selector(notiChangeNavBackData(_:)), name: NSNotification.Name("kChangeNavKey"), object: nil)
        let viewController = SDMineViewController()
        self.rootNavigation.setViewControllers([viewController], animated: true)
        let avm: Attachable<SDMineViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        
        let toNextDidSelectedSettingItem = viewModel.didSelectedSettingItem.filter { _ in
            SDUserManager.token != nil
        }
        weak var weakViewController = viewController
        toNextDidSelectedSettingItem.filter { model in
            model.cellType == .authentication
        }.asObservable().mapToVoid().withLatestFrom(viewModel.currentUser).filter { user in
            user.authStatus == 0
        }.flatMap { [unowned self] _ in
            self.showAuthentication(self.rootNavigation)
        }.subscribe(onNext: { _ in
            guard let strongViewController = weakViewController else { return }
            strongViewController.requestFetchTrigger.onNext(())
        }).disposed(by: disposeBag)
        
        toNextDidSelectedSettingItem.filter { model in
            model.cellType != .authentication
        }.asObservable().subscribe(onNext: { model in
            self.showNextPageViewController(self.rootNavigation, type: model.cellType)
        }).disposed(by: disposeBag)
        
        let logout = toNextDidSelectedSettingItem.filter { model in
            model.cellType == .setting
        }.asObservable().mapToVoid().flatMap { [unowned self] _ in
            self.goSettingPage(self.rootNavigation)
        }
        
        let toLoginTrigger = viewModel.didSelectedSettingItem.filter { _ in
            SDUserManager.token == nil
        }.do(onNext: { [unowned self] _ in
            self.dependencies.usermanager.authenticationState = .signedOut
        }).asObservable().mapToVoid()
        
        viewModel.tapInputNameTrigger.asObservable().flatMap { [unowned self] nickName in
            self.showInputNameViewController(self.rootNavigation, nickName)
        }.flatMap { [unowned self] newNickName in
            self.dependencies.userInfoService.updateUserInfo(nickName: newNickName, avatar: nil)
        }.subscribe(onNext: { _ in
            guard let strongViewController = weakViewController else { return }
            strongViewController.requestFetchTrigger.onNext(())
        }).disposed(by: disposeBag)
        
        viewModel.tapAvatarTrigger.asObservable().subscribe(onNext: { [unowned self] _ in
            guard let strongViewController = weakViewController else { return }
            self.showPhotoPreviewSheet(strongViewController);
        }).disposed(by: disposeBag)
        
        viewModel.updateImageRequestResult.flatMap { [unowned self]  imageUrl in
            return self.dependencies.userInfoService.updateUserInfo(nickName: nil, avatar: imageUrl);
        }.subscribe(onNext: { _ in
            guard let strongViewController = weakViewController else { return }
            strongViewController.requestFetchTrigger.onNext(())
        }).disposed(by: disposeBag)
        
        
        
        return Observable.merge(logout, toLoginTrigger, viewModel.toLoginTrigger.asObservable()).take(1)
    }

    private func showPhotoPreviewSheet(_ controller: SDMineViewController) {
        let ps = ZLPhotoPreviewSheet()

        let config = ZLPhotoConfiguration.default()
        
        config.allowSelectImage = true
        config.allowSelectVideo = false
        
        config.allowSelectGif = false
        config.allowSelectLivePhoto = false
        config.allowSelectOriginal = false
        config.cropVideoAfterSelectThumbnail = true
        config.allowEditVideo = true
        config.allowMixSelect = false
        config.maxSelectCount = 1;
        
        weak var weakController = controller;
        ps.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            guard let strongController = weakController else { return }
            guard let firstImage = images.first else { return }
            strongController.uploadImageFilterTrigger.onNext(firstImage);
        }
        ps.showPreview(animate: true, sender: self.rootNavigation)
    }
    
    private func showAuthentication(_ rootViewController: UIViewController) -> Observable<Void> {
        let authentication = SDAuthenticationCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: authentication)
    }

    private func goSettingPage(_ navigation: UINavigationController) -> Observable<Void> {
        let setting = SPSettingCoordinator(rootNavigation: navigation, dependencies: dependencies)
        return coordinate(to: setting)
    }
    
    private func showInputNameViewController(_ navigation: UINavigationController, _ nickName: String) -> Observable<String> {
        let viewController = SDInputNameViewController(nickName)
        viewController.modalPresentationStyle = .overCurrentContext
        navigation.definesPresentationContext = true
        navigation.providesPresentationContextTransitionStyle = true
        navigation.present(viewController, animated: false)
        return viewController.inputNameTrigger.asObserver()
    }
    
    private func showNextPageViewController(_ rootViewController: UIViewController, type: SDMineCellType) {
        switch type {
        case .seatGameLog:
            self.goToGameLogViewController(type: type)
        case .wawajGameLog:
            self.goToGameLogViewController(type: type)
        case .myAppeal:
            self.goToGameApealLogViewController()
        case .consumptionRecord:
            self.goToRecordViewController()
        case .invitedShared:
            self.goToInviteSharedViewController()
        case .setting:
            break
        case .authentication:
            break
        default: break
        }
    }
    
    private func goToInviteSharedViewController() {
        let viewController = SDInvitedCodeViewController()
        let avm: Attachable<SDInvitedCodeViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(viewController, animated: true)
    }
    
    private func goToGameLogViewController(type: SDMineCellType) {
        let viewController = SDGameLogViewController(type == .seatGameLog ? .logForSeat : .logForWWj)
        let avm: Attachable<SDGameLogViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(viewController, animated: true)
        viewModel.didSelectedItem.asObservable().subscribe(onNext: { [unowned self] model in
            self.goToGameLogDetailViewController(model: model)
        }).disposed(by: disposeBag)
    }

    private func goToGameLogDetailViewController(model: SDGameLogItemModel) {
        let viewController = SPGameLogDetailViewController(model.originData)
        let avm: Attachable<SPGameLogDetailViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        self.rootNavigation.pushViewController(viewController, animated: true)
    }

    private func goToGameApealLogViewController() {
        let viewController = SPGameApealLogViewController()
        let avm: Attachable<SPGameApealLogViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(viewController, animated: true)
            
        viewModel.didSelectedItem.asObservable().subscribe(onNext: { [unowned self] model in
            self.goToGameAppealDeatilViewController(model)
        }).disposed(by: disposeBag)
    }

    private func goToGameAppealDeatilViewController(_ model: SDGameComplaintViewModel) {
        let viewController = SPGameApealDeatilViewController(model.originData)
        let avm: Attachable<SPGameApealDeatilViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(viewController, animated: true)
    }

    private func goToRecordViewController() {
        let viewController = SRrecordViewController()
        let avm: Attachable<SRrecordViewModel> = .detached(self.dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.hidesBottomBarWhenPushed = true
        self.rootNavigation.pushViewController(viewController, animated: true)
    }
}

class SDAuthenticationCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies = HadCustomService
    
    private let rootViewController: UIViewController
    private let dependencies: Dependencies

    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<Void> {
        let viewController = SDAuthenticationViewController()
        let avm: Attachable<SDAuthenticationViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.modalPresentationStyle = .overCurrentContext
        rootViewController.definesPresentationContext = true
        rootViewController.providesPresentationContextTransitionStyle = true
        rootViewController.present(viewController, animated: false)
        
        weak var weakViewController = viewController
        return Driver.merge(viewModel.authenticationResult).asObservable().do(onNext: { _ in
            DispatchQueue.main.async {
                weakViewController?.dismiss(animated: false)
            }
        }).mapToVoid()
    }
}
