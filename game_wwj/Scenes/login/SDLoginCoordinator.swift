//
//  SDLoginCoordinator.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/2.
//

import UIKit
import RxCocoa
import RxSwift




class SDLoginCoordinator: SDBaseCoordinator<Void> {
    typealias Dependencies =  HadUserManager & HadCustomService;
    
    private let window: UIWindow
    private let dependencies: Dependencies
        
    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewController = SDLoginViewController();
        let rootNavitation = UINavigationController(rootViewController: viewController);
        let avm : Attachable<SDLoginViewModel> = .detached(self.dependencies);
        let viewModel = viewController.attach(wrapper: avm);
        let didLogin = viewModel.didLoginByPhone.asObservable().flatMap { [weak self] _ -> Observable<SDLoginByPhoneCoordinationResult> in
            guard let strongSelf = self else { return .empty() }
            return strongSelf.showLoginByPhone(on: viewController)
        }.filter { $0 == .login }.map { _ in
            return;
        }
        let appleLogin = viewModel.loggedIn.asObservable().mapToVoid();
        window.rootViewController = rootNavitation
        window.makeKeyAndVisible()
//        return Observable.merge(didLogin, appleLogin).take(1);
        return Observable.merge(didLogin, appleLogin, viewModel.toCloseTrigger.asObservable()).take(1);
    }
    
    private func showLoginByPhone(on rootViewController: UIViewController)  -> Observable<SDLoginByPhoneCoordinationResult> {
        let loginByPhoneCoordinator = SDLoginByPhoneCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: loginByPhoneCoordinator);
    }
}
enum SDLoginByPhoneCoordinationResult {
    case login
    case cancel
}

class SDLoginByPhoneCoordinator :SDBaseCoordinator<SDLoginByPhoneCoordinationResult> {
    typealias Dependencies =  HadUserManager & HadCustomService;
    
    private var rootViewController: UIViewController
    private let dependencies: Dependencies

    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }        
    
    override func start() -> Observable<SDLoginByPhoneCoordinationResult> {

        let viewController = SDLoginByPhoneViewController();
        let avm: Attachable<SDLoginByPhoneViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)
        viewController.modalPresentationStyle = .overCurrentContext;
        rootViewController.definesPresentationContext = true;
        rootViewController.providesPresentationContextTransitionStyle = true;
        rootViewController.present(viewController, animated: false)
        
        let cancel = viewModel.cancelTaps.asObservable().map { _ in
            return SDLoginByPhoneCoordinationResult.cancel;
        }
        let login = viewModel.loginResult.asObservable().filter{ $0 }.map { _ in
            return SDLoginByPhoneCoordinationResult.login;
        }
        weak var weakViewController = viewController;
        return Observable.merge(cancel, login).take(1).do(onNext: { _ in weakViewController?.dismiss(animated: false)})
    }
}

