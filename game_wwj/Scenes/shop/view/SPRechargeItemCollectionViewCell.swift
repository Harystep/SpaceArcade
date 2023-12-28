//
//  SPRechargeItemCollectionViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/14.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SPRechargeItemCollectionViewCell: UICollectionViewCell , SDCollectionItemType {
    private let rootFlexContainer: UIView = UIView();

    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_charge_item_bg"))
        return theView;
    }()
    
    lazy var theChargeLogoImageView: UIImageView = {
        let theView = UIImageView.init()
        return theView;
    }()
    lazy var theChargeValueLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.white;
        theView.font = UIFont.boldSystemFont(ofSize: 40)~
        return theView;
    }()
    
    lazy var theLineView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_charge_item_line"))
        return theView;
    }()
    
    lazy var theContentBgImageView: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theContentDesLabel: UILabel = {
        let theView = UILabel.init()
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 28, weight: .medium)~;
        return theView;
    }()
    
    lazy var theFreeDiamondLogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_charge_item_diamod"));
        theView.contentMode = .scaleAspectFit;
        return theView;
    }()
    
    lazy var thePriceLabel : UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.boldSystemFont(ofSize: 36)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var theToBuyTipLabel : UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.textColor = UIColor.white;
        theView.text = "去购买";
        return theView;
    }()
    lazy var theToBuyTipImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_charge_next"))
        return theView;
    }()
    
    var gradientLayer : CAGradientLayer?

    override init(frame: CGRect) {
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
        self.gradientLayer?.frame = self.theContentBgImageView.bounds;
    }
    
    func bind(to viewModel: SDCollectionViewModel) {
        if let model = viewModel as? SPRechargeItemViewModel {
            if let type = model.originData.type {
                if type == 1 {
                    self.theChargeLogoImageView.image = UIImage(named: "ico_charge_card_item_diamond");
                } else if type == 2 {
                    self.theChargeLogoImageView.image = UIImage(named: "space_coin_icon");
                }
            }
            self.theChargeValueLabel.text = String.init(format: "%.0f", model.originData.money);
            self.theContentDesLabel.text = "次日再送\(String.init(format: "%.0f", model.originData.price))"
            self.thePriceLabel.text = "¥\(String.init(format: "%.0f", model.originData.price))"
            self.theChargeValueLabel.flex.markDirty();
            self.theContentDesLabel.flex.markDirty();
            self.thePriceLabel.flex.markDirty();
            self.rootFlexContainer.flex.layout();
        }
    }
    
    
}

private extension SPRechargeItemCollectionViewCell {
    func configView() {
        self.contentView.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
            flex.addItem().direction(.column).alignItems(.center).define { [unowned self] flex in
                flex.addItem().direction(.row).marginTop(44~).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theChargeLogoImageView).width(48~).height(48~);
                    flex.addItem(self.theChargeValueLabel);
                }
                flex.addItem(self.theLineView).width(292~).height(2~).marginTop(8~);
                flex.addItem().width(264~).height(82~).marginTop(28~).direction(.row).alignItems(.center).justifyContent(.center).define { [unowned self] flex in
                    if AppDefine.needDiamond {
                        flex.addItem(self.theContentBgImageView).width(100%).height(100%).position(.absolute);
                        flex.addItem().direction(.row).alignItems(.start).define { [unowned self] flex in
                            flex.addItem(self.theContentDesLabel);
                            flex.addItem(self.theFreeDiamondLogoImageView).width(46~).height(46~);
                        }
                    }
                    
                }
                flex.addItem().width(100%).marginTop(35~).height(63~).direction(.row).alignItems(.center).justifyContent(.spaceBetween).define { [unowned self] flex in
                    flex.addItem(self.thePriceLabel).marginLeft(48~);
                    flex.addItem().direction(.row).alignItems(.center).marginRight(26~).define { [unowned self] flex in
                        flex.addItem(self.theToBuyTipLabel);
                        flex.addItem(self.theToBuyTipImageView).width(32~).height(18~);
                    }
                }
            }
        }
        gradientLayer = CAGradientLayer()
           //设置渐变的主颜色
        gradientLayer!.colors = [UIColor.init(hexString: "#EEEEEE", alpha: 0)!.cgColor, UIColor.init(hexString: "#998FD4", alpha: 0.53)!.cgColor, UIColor.init(hexString: "#EEEEEE", alpha: 0)!.cgColor]
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0);
        gradientLayer!.endPoint = CGPoint(x: 1, y: 0);
           //将gradientLayer作为子layer添加到主layer上
        self.theContentBgImageView.layer.addSublayer(gradientLayer!)
    }
}
