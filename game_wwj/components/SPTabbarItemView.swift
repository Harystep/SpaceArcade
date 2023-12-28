//
//  SPTabbarItemView.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/28.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SPTabbarItemView: UIControl {
    private let rootFlexContainer: UIView = UIView();
    
    
    lazy var theTabbarLogoImageView: UIImageView = {
        let theView = UIImageView()
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theTabbarSelectedImageView: UIImageView = {
        let theView = UIImageView();
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    lazy var theTabbarTitleView: UIView = {
        let theView = UIView.init()
        return theView;
    }()
    lazy var theTabbarTitleLabel: UILabel = {
        let theView = UILabel();
        theView.isUserInteractionEnabled = false;
        theView.font = UIFont.systemFont(ofSize: 24)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    let tabbarItem: UITabBarItem;
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.theTabbarLogoImageView.flex.display(.none)
                self.theTabbarSelectedImageView.flex.display(.flex)
                self.theTabbarTitleView.flex.top(80~);
                self.theTabbarTitleLabel.textColor = UIColor.init(hex: 0xEDAA29);
            } else {
                self.theTabbarLogoImageView.flex.display(.flex)
                self.theTabbarSelectedImageView.flex.display(.none);
                self.theTabbarTitleView.flex.top(88~);
                self.theTabbarTitleLabel.textColor = UIColor.white;
            }
            self.rootFlexContainer.flex.layout();
        }
    }
    
    init(_ item: UITabBarItem) {
        tabbarItem = item;
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

private extension SPTabbarItemView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false;
        self.rootFlexContainer.flex.direction(.column).alignItems(.center).define { [unowned self] flex in
            flex.addItem().height(102~).width(100%).direction(.column).alignItems(.center).define { [unowned self] flex in
                flex.addItem().width(120~).height(120~).justifyContent(.center).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theTabbarLogoImageView).width(120~).height(120~).marginTop(-28~);
                    flex.addItem(self.theTabbarSelectedImageView).display(.none).width(144~).height(144~).marginTop(-52~)
                }
                flex.addItem(self.theTabbarTitleView).justifyContent(.center).alignItems(.center).width(100%).position(.absolute).top(68~).define { [unowned self] flex in
                    flex.addItem(self.theTabbarTitleLabel)
                }
            }
            
        }
        self.theTabbarTitleLabel.text = self.tabbarItem.title;
        
        self.theTabbarLogoImageView.image = self.tabbarItem.image;
        self.theTabbarSelectedImageView.image = self.tabbarItem.selectedImage;
        
    }
}
