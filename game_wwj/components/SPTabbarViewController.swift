//
//  SPTabbarViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/28.
//

import UIKit

import RxSwift
import RxCocoa

class SPTabbarViewController: UITabBarController {
    
    var tabbarView: SPCustomTabbar?;
    var isFirstLoad: Bool  = true;
    
    let tabItemList: [UITabBarItem]
    
    let toLoginTrigger: PublishSubject<Void> = PublishSubject();
    
    init( _ list: [UITabBarItem]) {
        self.tabItemList = list;
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configView();
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.init(hex: 0x22203A);
        tabBar.standardAppearance = appearance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.tabBar.subviews.forEach { view in
            if let controll = view as? UIControl {
                controll.removeFromSuperview();
            }
        }
        if self.isFirstLoad {
            self.selectedIndex = 2;
            self.isFirstLoad = false;
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        log.debug("[tabbar] didSelected \(item.tag)");
        if (SDUserManager.token == nil) {
            self.toLoginTrigger.onNext(());
            return;
        }
        self.tabbarView!.updateTabbarItemIndex(item.tag);
    }
}

extension SPTabbarViewController: SPTabbarDelegate {
    func tabbar(tabbar: SPCustomTabbar, didSelect item: SPTabbarItemView) {
        
        if (SDUserManager.token == nil) {
            self.toLoginTrigger.onNext(());
            return;
        }
        
        tabbar.updateTabbarItemIndex(item.tabbarItem.tag);
        self.selectedIndex = item.tabbarItem.tag;
    }
}

private extension SPTabbarViewController {
    func configView() {
        self.tabbarView = SPCustomTabbar(frame: self.tabBar.bounds, list: self.tabItemList);
        self.tabbarView?.tabbarDelegate = self;
        self.tabbarView?.selectedIndex = 2;
        self.setValue(self.tabbarView, forKey: "tabBar");
        
        self.tabBar.unselectedItemTintColor = UIColor.white;
        self.tabBar.tintColor = UIColor.init(hex: 0xEDAA29);
    }
}
