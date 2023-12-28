//
//  SPLineTabView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize


protocol SPLineTabDelegate: class {
    func SPTabView(tabView: SPLineTabView, didSelected index: Int);
}
class SPLineTabView: UIView {
    private let rootFlexContainer: UIView = UIView();
    let tabList: [String]
    var selectedIndex: Int = 0 {
        didSet {
            self.tabViewList.forEach { view in
                view.isSelected = false;
            }
            if let selectedView = self.tabViewList[selectedIndex] as? SPLineTabItemView {
                selectedView.isSelected = true;
            }
        }
    }
    
    weak var tabDelegate: SPLineTabDelegate?
    
    var tabViewList: [SPLineTabItemView] = [];
    
    init(_ list: [String]) {
        self.tabList = list;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
    }
}

private extension SPLineTabView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.backgroundColor = UIColor.clear;
        self.rootFlexContainer.flex.direction(.row).define { [unowned self] flex in
            for index in 0..<self.tabList.count {
                let item = self.tabList[index];
                flex.addItem(self.createTabItem(item, tabTag: index)).height(100%).grow(1);
            }
        }
    }
    func createTabItem(_ tab: String, tabTag: Int) -> SPLineTabItemView {
        let theView = SPLineTabItemView.init(tab);
        theView.tag = tabTag;
        theView.addTarget(self, action: #selector(onTapTabPress(_:)), for: .touchUpInside);
        self.tabViewList.append(theView);
        if tabTag == self.selectedIndex {
            theView.isSelected = true;
        }
        return theView;
    }
    @objc func onTapTabPress(_ sender: UIButton) {
        self.selectedIndex = sender.tag;
        self.tabDelegate?.SPTabView(tabView: self, didSelected: sender.tag);
    }
}
