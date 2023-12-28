//
//  SDSeatPlayerView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

import SDWebImage
import SwiftHEXColors

class SDSeatPlayerView: UIView {
    fileprivate let rootFlexController = UIView();
    
    let seatPlayerIndex : Int
    
    lazy var thePlaySeatView: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.init(hex: 0x8258C1);
        return theView;
    }()
    
    lazy var thePlaySeatLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 20)~;
        theView.textColor = UIColor.white;
        theView.textAlignment = .center;
        return theView;
    }()
    
    lazy var theAvatarImageView: UIImageView = {
        let theView = UIImageView.init();
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theSeatView: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.init(hex: 0x8258C1);
        theView.isUserInteractionEnabled = false;
        theView.isHidden = true;
        return theView;
    }()
    
    lazy var theSeatLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 20, weight: .medium)~;
        theView.textColor = UIColor.white;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    
    var playerInfo: SDSaintSeatInfoData? = nil {
        didSet {
            if playerInfo != nil {
                self.theAvatarImageView.sd_setImage(with: URL(string: playerInfo!.headUrl));
                self.thePlaySeatView.isHidden = true;
                self.theSeatView.isHidden = false;
            } else {
                self.theAvatarImageView.image = nil;
                self.thePlaySeatView.isHidden = false;
                self.theSeatView.isHidden = true;
            }
        }
    }
    init(_ index: Int) {
        seatPlayerIndex = index;
        super.init(frame: CGRect.zero);
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
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%);
        
        self.theAvatarImageView.layer.masksToBounds = true;
        self.theAvatarImageView.layer.cornerRadius = 32~;
        
    
        
        self.theSeatView.layer.masksToBounds = true;
        self.theSeatView.layer.cornerRadius = 14~;
        
        
       
        self.rootFlexController.flex.layout();

    }
}

private extension SDSeatPlayerView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.isUserInteractionEnabled = false;
        self.theSeatLabel.text = "\(self.seatPlayerIndex)P";
        self.thePlaySeatLabel.text = "\(self.seatPlayerIndex)P";
        self.rootFlexController.flex.direction(.column).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theAvatarImageView).width(64~).height(64~).define { [unowned self] flex in
                flex.addItem(self.thePlaySeatView).width(64~).height(64~).justifyContent(.center).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.thePlaySeatLabel);
                }
            }
            
            flex.addItem(self.theSeatView).width(78~).height(28~).marginTop(-14~).justifyContent(.center).alignItems(.center).define { [unowned self] flex in
                flex.addItem(self.theSeatLabel);
            }
        }
    }
}
