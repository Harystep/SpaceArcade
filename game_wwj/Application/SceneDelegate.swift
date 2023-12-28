//
//  SceneDelegate.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/24.
//

import UIKit
import RxSwift
import SwiftyBeaver
import SwiftyFitsize
import IQKeyboardManager

let log = SwiftyBeaver.self
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!
    private let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light;
        }
        
        window?.frame = windowScene.coordinateSpace.bounds;
        self.configLog();
        SwiftyFitsize.reference(width: 750, iPadFitMultiple: 1);
        self.appCoordinator = AppCoordinator(window: self.window!);
        self.appCoordinator.start().subscribe().disposed(by: self.disposeBag);
        
//        let screenVC = YDScreenController()
//        screenVC.appCoordinator = self.appCoordinator
//        self.window?.rootViewController = screenVC
//        self.window?.makeKeyAndVisible()
        
        IQKeyboardManager.initialize()
        self.configApplication();
        
//        for family: String in UIFont.familyNames {
//            print(family)
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    private func configLog() {
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        console.format = "$DHH:mm:ss$d $L $M"
        log.addDestination(console)
        log.addDestination(file)
    }
    
    private func configApplication() {
        
        TXCommonHandler.sharedInstance().setAuthSDKInfo(AppDefine.PNSATAUTHSDKINFO) { result in
            log.debug("[设置秘钥结果] : \(result)");
        }
        
    }


}

