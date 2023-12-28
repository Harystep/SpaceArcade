//
//  SDGameRoomStatusView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/19.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
class SDGameRoomStatusView: UIView {
    fileprivate let rootFlexController = UIView();
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28, weight: .medium)~;
        theView.textColor = UIColor.white;
        if self.status == 0 {
            theView.text = "空闲中";
        } else if self.status == 1 {
            theView.text = "热玩中";
        } else if self.status == 2 {
            theView.text = "维护中";
        }
        return theView;
    }()
    let maskLayer = CAShapeLayer();
    var status: Int = 0 {
        didSet {
            if self.status == 0 {
                theTitleLabel.text = "空闲中";
                self.rootFlexController.backgroundColor = UIColor.init(hex: 0x179933)
            } else if self.status == 1 {
                theTitleLabel.text = "热玩中";
                self.rootFlexController.backgroundColor = UIColor.init(hex: 0xFF4D4D)
            } else if self.status == 2 {
                theTitleLabel.text = "维护中";
                self.rootFlexController.backgroundColor = UIColor.gray;
            }
        }
    }
    
    init() {
        
        super.init(frame: CGRect.zero);
        self.configView();
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.width(100%).height(100%).left().top();
        self.rootFlexController.flex.layout();
        
        self.maskLayer.path = UIBezierPath(roundedRect: self.rootFlexController.bounds, byRoundingCorners: [.topRight, .bottomLeft], cornerRadii: CGSize(width: 20, height: 20)~).cgPath;
    }
}

private extension SDGameRoomStatusView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theTitleLabel)
        }
        self.rootFlexController.layer.mask = self.maskLayer;
    }
}
