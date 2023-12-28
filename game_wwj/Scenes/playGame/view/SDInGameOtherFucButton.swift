//
//  SDInGameOtherFucButton.swift
//  game_wwj
//
//  Created by sander shan on 2023/7/19.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
class SDInGameOtherFucButton: UIControl {
    
    fileprivate let rootFlexController = UIView();
    
    
    lazy var theImageView: UIImageView = {
        let theView = UIImageView(image: self.buttonImage);
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init()
        theView.text = self.buttonTitle;
        theView.font = UIFont.systemFont(ofSize: 18, weight: .medium)~;
        theView.textColor = UIColor.white;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    let buttonImage: UIImage;
    let selectedButtonImage: UIImage;
    let buttonTitle: String;
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.theImageView.image = self.selectedButtonImage;
            } else {
                self.theImageView.image = self.buttonImage;
            }
        }
    }
    
    init(_ image: UIImage, _ title: String) {
        self.buttonImage = image;
        self.selectedButtonImage = image;
        self.buttonTitle = title;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    init(_ image: UIImage, _ selectedImage: UIImage, _ title: String) {
        self.buttonImage = image;
        self.selectedButtonImage = selectedImage;
        self.buttonTitle = title;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().height(100%).width(100%);
        self.rootFlexController.flex.layout();
    }
}

private extension SDInGameOtherFucButton {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.isUserInteractionEnabled = false;
        self.rootFlexController.flex.direction(.column).define { [unowned self] flex in
            flex.addItem(self.theImageView).width(60~).height(60~);
            flex.addItem().width(60~).height(24~).cornerRadius(12~).marginTop(-12~).justifyContent(.center).alignItems(.center).backgroundColor(UIColor.init(white: 0, alpha: 0.55)).define { [unowned self] flex in
                flex.addItem(self.theTitleLabel);
            }
        }
    }
}
