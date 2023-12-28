//
//  SDGameRoomItemCollectionViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
import SDWebImage

class SDGameRoomItemCollectionViewCell: UICollectionViewCell, SDCollectionItemType {
    fileprivate let rootFlexController = UIView();
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView()
        theView.contentMode = .scaleAspectFill;
        return theView;
    }()
    lazy var theStatusView: SDGameRoomStatusView = {
        let theView = SDGameRoomStatusView();
        return theView;
    }()
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30, weight: .medium)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var thePriceLogoImageView: UIImageView = {
        let theView = UIImageView()
        return theView;
    }()
    
    lazy var thePriceLabel: UILabel = {
        let theView = UILabel.init()
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 28, weight: .medium)~;
        return theView;
    }()
    
    lazy var theVipTagView: SDRoomTagView = {
        let theView = SDRoomTagView();
        theView.setbackGroupColor(UIColor.init(hex: 0xBA851E)!)
        return theView;
    }()
    
    lazy var thePointTagView: SDRoomTagView = {
        let theView = SDRoomTagView();
//        theView.backgroundColor = UIColor.init(hex: 0x4230AE)
        theView.setbackGroupColor(UIColor.init(hex: 0x4230AE)!)

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
        self.rootFlexController.pin.width(100%).height(100%).left().top();
        self.rootFlexController.flex.layout();
    }
    func bind(to viewModel: SDCollectionViewModel) {
        if let model = viewModel as? SDGameRoomItemViewModel {
            self.theStatusView.status = model.originData.status;
            
            self.theBgImageView.sd_setImage(with: URL(string: model.originData.roomImg));
            
            self.theTitleLabel.text = model.originData.roomName;
            
            if model.originData.costType == 1 {
                /// 钻石
                self.thePriceLogoImageView.image = UIImage(named: "ico_bt_diamond")
                self.thePriceLabel.text = "\(model.originData.cost)钻石/次"
            } else {
                self.thePriceLogoImageView.image = UIImage(named: "space_coin_icon")
                self.thePriceLabel.text = "\(model.originData.cost)太空币/次"
            }
            if model.originData.minLevel > 1 {
                self.theVipTagView.tagTitle = "vip\(model.originData.minLevel)+";
                self.theVipTagView.isHidden = false;
            } else {
                self.theVipTagView.isHidden = true;
            }
            self.thePointTagView.tagTitle = "能量x\(model.originData.multiple)";
            
        }
    }
}

private extension SDGameRoomItemCollectionViewCell {
    func configView() {
        self.contentView.addSubview(self.rootFlexController);
        self.rootFlexController.backgroundColor = UIColor.white;
        self.rootFlexController.layer.masksToBounds = true;
        self.rootFlexController.layer.cornerRadius = 20~;
        self.rootFlexController.flex.define { [unowned self] flex in
            flex.addItem().width(100%).height(294~).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem(self.theStatusView).position(.absolute).top(0).right(0).width(112~).height(42~);
                flex.addItem(self.theVipTagView).width(108~).height(48~).position(.absolute).left(0).top(172~);
                flex.addItem(self.thePointTagView).width(108~).height(48~).position(.absolute).left(0).bottom(16~);
            }
            flex.addItem().backgroundColor(UIColor.init(hex: 0xEEAA29)!).grow(1).justifyContent(.center).alignItems(.center).define { flex in
                flex.addItem().backgroundColor(UIColor.init(hex: 0x9D701A)!).cornerRadius(10~).width(310~).height(106~).direction(.column).alignItems(.center).justifyContent(.center).define { [unowned self] flex in
                    flex.addItem(self.theTitleLabel);
                    flex.addItem().direction(.row).alignItems(.center).define { [unowned self] flex in
                        flex.addItem(self.thePriceLogoImageView).width(52~).height(52~);
                        flex.addItem(self.thePriceLabel);
                    }
                }
            }
        }
    }
}
