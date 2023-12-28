//
//  SDVerticalImageAndTitleButton.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/14.
//

import UIKit

import PinLayout
import FlexLayout

import SwiftyFitsize
import SwiftHEXColors

class SDVerticalImageAndTitleButton: UIControl {

    fileprivate let rootFlexController = UIView();

    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.init(hex: 0x333333);
        theView.font = UIFont.systemFont(ofSize: 26, weight: .medium)~;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theLogoImageView: UIImageView = {
        let theView = UIImageView.init();
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    private let imageSize: CGSize;
    
    init(imgSize: CGSize) {
        self.imageSize = imgSize;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    override init(frame: CGRect) {
        self.imageSize = CGSize.zero;
        super.init(frame: frame);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%);
        self.rootFlexController.flex.layout();
    }
    
}
private extension SDVerticalImageAndTitleButton {
    func configView() {
        self.rootFlexController.isUserInteractionEnabled = false;
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.direction(.column).alignItems(.center).justifyContent(.center).define { [unowned self] flex in
            flex.addItem(self.theLogoImageView).size(self.imageSize);
            flex.addItem(self.theTitleLabel);
        }
    }
}
