//
//  SPCustomTabbar.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/28.
//

import UIKit
import FlexLayout
import PinLayout

import SwiftyFitsize

import SwiftHEXColors

protocol SPTabbarDelegate: class {
    func tabbar(tabbar: SPCustomTabbar, didSelect item: SPTabbarItemView);
}

class SPCustomTabbar: UITabBar {
    
    private let rootFlexContainer: UIView = UIView();

    weak var tabbarDelegate: SPTabbarDelegate?
    
    private var viewList: [SPTabbarItemView] = [];
    
    lazy var theImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_selected_bottom"));
        return theView
    }()
    
    var selectedIndex = 0;
    
    let tabItemList: [UITabBarItem]
    
    init(frame: CGRect, list: [UITabBarItem]) {
        self.tabItemList = list;
        super.init(frame: frame);
        self.configView();
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
        
        var viewIndex = 0;
        self.viewList.forEach { view in
            view.isSelected = false;
            if viewIndex == self.selectedIndex {
//                self.theImageView.frame = CGRect(x: view.frame.origin.x + 4, y: view.frame.maxY - 154~ + 16~, width: 126~, height: 154~)
                self.theImageView.center = view.center;
                self.theImageView.frame = CGRect(origin: CGPoint(x: self.theImageView.frame.origin.x, y: view.frame.maxY - 154~ + 16~), size: CGSize.init(width: 126~, height: 154~))
                view.isSelected = true;
            }
            viewIndex += 1;
        }
    }
    
    func updateTabbarItemIndex(_ index: Int) {
        log.debug("[updateTabbarItemIndex] --> \(index)")
        self.selectedIndex = index;
        var viewIndex = 0;
        self.viewList.forEach { view in
            view.isSelected = false;
            if viewIndex == self.selectedIndex {
                self.theImageView.center = view.center;
                self.theImageView.frame = CGRect(origin: CGPoint(x: self.theImageView.frame.origin.x, y: view.frame.maxY - 154~ + 16~), size: CGSize.init(width: 126~, height: 154~))
                view.isSelected = true;
            }
            viewIndex += 1;
        }
    }
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.backgroundColor = UIColor.init(hex: 0x22203A);

        self.rootFlexContainer.flex.direction(.row).define { [unowned self] flex in
            flex.addItem(self.theImageView).position(.absolute);
            self.tabItemList.forEach { item in
                flex.addItem(self.createTabbarItem(item)).height(100%).grow(1);
            }
        }
    }
    
    @objc func onTapTabbarItem(_ control : UIControl) {
        if let tabbar = control as? SPTabbarItemView {
            self.tabbarDelegate?.tabbar(tabbar: self, didSelect: tabbar);
        }
    }
    
    func createTabbarItem(_ item: UITabBarItem) -> SPTabbarItemView {
        let theView = SPTabbarItemView(item);
        theView.addTarget(self, action: #selector(onTapTabbarItem(_:)), for: .touchUpInside);
        viewList.append(theView);
        return theView;
    }
}

