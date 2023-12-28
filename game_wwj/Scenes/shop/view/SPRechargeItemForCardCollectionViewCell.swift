//
//  SPRechargeItemForCardCollectionViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/14.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SPRechargeItemForCardCollectionViewCell: UICollectionViewCell, SDCollectionItemType {
    private let rootFlexContainer: UIView = UIView();
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_month_card_bg"))
        theView.contentMode = .scaleAspectFit;
        return theView;
    }()
    
    lazy var theLogoImageView: UIImageView = {
        let theView = UIImageView.init();
        return theView;
    }()
    
    lazy var theTip1Label: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.init(hex: 0x684709);
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        return theView;
    }()
    
    lazy var theTip1LogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "space_coin_icon"))
        return theView;
    }()
    
    lazy var theTip2Label: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.init(hex: 0x684709);
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        return theView;
    }()
    lazy var theTip2LogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_charge_card_item_diamond"))
        return theView;
    }()
    lazy var theTip3Label: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.init(hex: 0x684709);
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.numberOfLines = 0;
        return theView;
    }()
    lazy var theTip3LogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_charge_card_item_diamond"))
        return theView;
    }()
    
    lazy var theBuyBgView: SPGradientView = {
        let theView = SPGradientView.init([UIColor.init(hex: 0xFEEED0)!.cgColor, UIColor.init(hex: 0xF9D693)!.cgColor], CGPoint.zero, CGPoint.init(x: 1, y: 0));
        return theView;
    }()
    
    lazy var theBuyButton: UIButton = {
        let theView = UIButton.init();
        theView.setTitleColor(UIColor.init(hex: 0x684709), for: .normal);
        theView.isEnabled = false;
        return theView;
    }()
    
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
        self.theBuyBgView.layer.masksToBounds = true;
        self.theBuyBgView.layer.cornerRadius = 34~;
    }
    
    func bind(to viewModel: SDCollectionViewModel) {
        if let model = viewModel as? SPRechargeItemViewModel {
            if model.chargeType == .chargeForWeek {
                self.theLogoImageView.image = UIImage(named: "ico_weak_card");
                self.theBgImageView.image = UIImage(named: "ico_weak_card_bg")
            } else if model.chargeType == .chargeForMonth {
                self.theBgImageView.image = UIImage(named: "ico_month_card_bg")
                self.theLogoImageView.image = UIImage(named: "ico_month_card");
            }
            self.theTip1Label.text = "购买立得\(model.originData.money)太空币"
            self.theTip2Label.text = "每日赠送\(model.originData.dayMoney ?? 0)钻石"
//            self.theTip3Label.text = "次日再送\(String.init(format: "%.0f", model.originData.price))钻石"
            self.theTip3Label.text = "\(model.originData.desc)"
            
            self.theBuyButton.setTitle(String.init(format: "¥%.0f", model.originData.price), for: .normal);
            
            self.theTip1Label.flex.markDirty();
            self.theTip2Label.flex.markDirty()
            self.theTip3Label.flex.markDirty();
            self.rootFlexContainer.flex.layout();
        }
    }
    
    
}

private extension SPRechargeItemForCardCollectionViewCell {
    func configView() {
        self.contentView.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem().justifyContent(.center).alignItems(.center).width(720~).height(278~).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).width(100%).height(100%).position(.absolute);
                flex.addItem().width(100%).direction(.row).alignItems(.center).marginLeft(46~).define { [unowned self] flex in
                    flex.addItem(self.theLogoImageView).width(96~).height(96~);
                    flex.addItem().direction(.column).marginLeft(24~).grow(1).define { [unowned self] flex in
                        flex.addItem().direction(.row).alignItems(.start).height(46~).define { [unowned self] flex in
                            flex.addItem(self.theTip1Label);
//                            flex.addItem(self.theTip1LogoImageView).width(46~).height(46~);
                        }
                        if AppDefine.needDiamond {
                            flex.addItem().direction(.row).height(46~).alignItems(.center).define { [unowned self] flex in
                                flex.addItem(self.theTip2Label);
//                                flex.addItem(self.theTip2LogoImageView).width(36~).height(36~);
                            }
                            flex.addItem().direction(.row).alignItems(.center).define { [unowned self] flex in
                                flex.addItem(self.theTip3Label).width(380~);
//                                flex.addItem(self.theTip3LogoImageView).width(36~).height(36~);
                            }
                        }
                    }
                    flex.addItem(self.theBuyBgView).width(164~).height(68~).marginRight(52~).justifyContent(.center).alignItems(.center).define { [unowned self] flex in
                        flex.addItem(self.theBuyButton).width(100%).height(100%);
                    }
                }
            }
        }
    }
}
