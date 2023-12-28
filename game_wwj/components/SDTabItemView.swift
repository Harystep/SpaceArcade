//
//  SDTabItemView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SDTabItemView: UIControl {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.textColor = UIColor.init(hex: 0x6456B7);
        theView.text = self.tab;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theBgView: UIView = {
        let theView = UIView.init();
        theView.isUserInteractionEnabled = false;
        return theView;
    }()

    var gradientLayer : CAGradientLayer?
    let tab: String;
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.theTitleLabel.textColor = UIColor.white;
                self.theBgView.isHidden = false;
            } else {
                self.theTitleLabel.textColor = UIColor.init(hex: 0x6456B7);
                self.theBgView.isHidden = true;
            }
        }
    }
    init(_ title: String) {
        self.tab = title;
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
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = self.frame.size.height / 2.0;
        self.gradientLayer!.frame = self.theBgView.bounds;
    }
}
private extension SDTabItemView{
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false;
        self.rootFlexContainer.flex.alignItems(.center).justifyContent(.center).define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%);
            flex.addItem(self.theTitleLabel);
        }
        gradientLayer = CAGradientLayer()
           //设置渐变的主颜色
        gradientLayer!.colors = [UIColor.init(hexString: "#6857C6")!.cgColor, UIColor.init(hexString: "#4732C0")!.cgColor]
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0);
        gradientLayer!.endPoint = CGPoint(x: 1, y: 0);
           //将gradientLayer作为子layer添加到主layer上
        self.theBgView.layer.addSublayer(gradientLayer!)
        self.theBgView.isHidden = true;
    }
}
