//
//  AppCoordinator.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit
import RxSwift

class AppCoordinator: SDBaseCoordinator<Void> {
    private var window: UIWindow
    private let dependencies: AppDependency
    
    init(window: UIWindow) {
        self.window = window
        self.dependencies = AppDependency();
    }
    @objc func signOutBack(_ data:Notification) {
        ZCSaveUserData.saveUserToken("")
        SDUserManager.token = nil
        self.coordinateToRoot(basedOn: .signedOut)
    }
    override func start() -> Observable<Void> {
        coordinateToRoot(basedOn: dependencies.usermanager.authenticationState)
        NotificationCenter.default.addObserver(self, selector: #selector(signOutBack), name: NSNotification.Name("kJumpLogoUIKey"), object: nil)
        return .never()
    }
    
    private func coordinateToRoot(basedOn authState: AuthenticationState) {
        switch authState {
        case .signedIn, .signedNot:
            return showSplitView()
                .subscribe(onNext: { [weak self] authState in
                    self?.window.rootViewController = nil
                    self?.coordinateToRoot(basedOn: authState)
                })
                .disposed(by: disposeBag)
        case .signedOut:
            return showLogin()
                .subscribe(onNext: { [weak self] authState in
                    self?.window.rootViewController = nil
                    self?.coordinateToRoot(basedOn: authState)
                })
                .disposed(by: disposeBag)
        }
    }

    private func showSplitView() -> Observable<AuthenticationState> {
        let rootCoordinator = SDTabbarCoordinator(window: self.window, dependencies: self.dependencies);
        return coordinate(to: rootCoordinator)
            .map { [unowned self] _ in self.dependencies.usermanager.authenticationState }
    }

    private func showLogin() -> Observable<AuthenticationState> {
        let loginCoordinator = SDLoginCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: loginCoordinator)
            .map { [unowned self] _ in self.dependencies.usermanager.authenticationState }
    }
    
}
