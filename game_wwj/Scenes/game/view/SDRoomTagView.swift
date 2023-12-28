//
//  SDRoomTagView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/19.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
class SDRoomTagView: UIView {

    fileprivate let rootFlexController = UIView();
    
    let maskLayer = CAShapeLayer();
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    var tagTitle: String = "" {
        didSet {
            self.theTitleLabel.text = self.tagTitle;
            self.theTitleLabel.flex.markDirty();
            self.rootFlexController.flex.layout();
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
        
        self.maskLayer.path = UIBezierPath(roundedRect: self.rootFlexController.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)~).cgPath;
        
    }
    func setbackGroupColor(_ color: UIColor) {
        self.rootFlexController.backgroundColor = color;
    }

}
private extension SDRoomTagView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theTitleLabel);
        }
        
        self.rootFlexController.layer.mask = self.maskLayer;
    }
}
