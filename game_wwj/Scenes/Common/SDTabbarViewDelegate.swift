//
//  SDTabbarViewDelegate.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/14.
//

import UIKit

class SDTabbarViewDelegate: NSObject {
    override init() {
        super.init();
    }
}

extension SDTabbarViewDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
}

