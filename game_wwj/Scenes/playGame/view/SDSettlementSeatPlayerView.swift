//
//  SDSettlementSeatPlayerView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/21.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
import SDWebImage


class SDSettlementSeatPlayerView: UIControl {
    
    fileprivate let rootFlexController = UIView();
    
    
    let seatPlayerIndex : Int
    
    lazy var theSeatPlayerView: SDSeatPlayerView = {
        let theView = SDSeatPlayerView(seatPlayerIndex);
        theView.isUserInteractionEnabled = false;
        return theView
    }()
    
    lazy var theSettlementButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage.init(named: ""), for: .normal);
        theView.isUserInteractionEnabled = false;
        theView.isEnabled = false;
        theView.isHidden = true;
        return theView;
    }()
    
    var seatInfo: SDSaintSeatInfoData? = nil {
        didSet {
            self.theSettlementButton.isHidden = true;
            self.isEnabled = false;
            self.theSeatPlayerView.playerInfo = seatInfo;
            if self.seatInfo != nil {
//                self.theSeatPlayerView.theAvatarImageView.sd_setImage(with: URL.init(string: self.seatInfo!.headUrl));
                self.theSeatPlayerView.theAvatarImageView.sd_setImage(with: URL.init(string: self.seatInfo!.headUrl), placeholderImage: UIImage(named: "ico_default_avatar"), context: nil);
                if self.seatInfo!.isSelf! {
                    self.theSeatPlayerView.theAvatarImageView.layer.masksToBounds = true;
                    self.theSeatPlayerView.theAvatarImageView.layer.borderWidth = 4~;
                    self.theSeatPlayerView.theAvatarImageView.layer.borderColor = UIColor.init(hex: 0xFAE55E)!.cgColor;
//                    self.theSettlementButton.isHidden = false;
                    self.isEnabled = true;
                } else {
                    self.theSeatPlayerView.theAvatarImageView.layer.borderWidth = 0;
                }
            } else {
                self.theSeatPlayerView.theAvatarImageView.image = nil;
                self.theSeatPlayerView.theAvatarImageView.layer.borderWidth = 0;
            }
            
        }
    }
    
    init(_ index: Int) {
        seatPlayerIndex = index;
        super.init(frame: CGRectZero)
        self.isEnabled = false;
        self.configView();
        
    }
    override init(frame: CGRect) {
        seatPlayerIndex = 1;
        super.init(frame: frame);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rootFlexController.pin.left().top().width(100%).height(100%);
        self.rootFlexController.flex.layout();
    }
}


private extension SDSettlementSeatPlayerView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.isUserInteractionEnabled = false;
        self.rootFlexController.flex.direction(.column).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theSeatPlayerView).width(78~).height(86~);
            flex.addItem(self.theSettlementButton).width(80~).height(50~);
        }
    }
}





