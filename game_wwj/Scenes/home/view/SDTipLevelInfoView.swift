//
//  SDTipLevelInfoView.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/31.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SDTipLevelInfoView: UIView {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theTipLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 24, weight: .medium)~;
        theView.textColor = UIColor.white;
        theView.text = "";
        return theView;
    }()
    
    lazy var theLayerView: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    var bggradientLayer: CAGradientLayer?
    var gradientLayer: CAGradientLayer?
    
    var tip: String = "" {
        didSet {
            self.theTipLabel.text = tip;
            self.theTipLabel.flex.markDirty();
            self.theTipLabel.flex.layout();
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
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
        self.bggradientLayer!.frame = self.bounds;
        self.gradientLayer!.frame = CGRect(x: 1, y: 1, width: self.bounds.size.width - 2, height: self.bounds.size.height - 2);
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 24~;
    }
    
    
}

private extension SDTipLevelInfoView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.alignItems(.center).justifyContent(.center).define { [unowned self] flex in
            flex.addItem(self.theLayerView).position(.absolute).width(100%).height(100%);
            flex.addItem(self.theTipLabel);
        }
        
        bggradientLayer = CAGradientLayer()
           //设置渐变的主颜色
        bggradientLayer!.colors = [UIColor.init(hexString: "#FFE6E6", alpha: 0)!.cgColor, UIColor.init(hexString: "#FFCFCB", alpha: 0.1)!.cgColor]
        bggradientLayer!.startPoint = CGPoint(x: 0, y: 0);
        bggradientLayer!.endPoint = CGPoint(x: 1, y: 0);
           //将gradientLayer作为子layer添加到主layer上
        self.theLayerView.layer.addSublayer(bggradientLayer!)
        
        gradientLayer = CAGradientLayer()
           //设置渐变的主颜色
        gradientLayer!.colors = [UIColor.init(hexString: "#F63A1D")!.cgColor, UIColor.init(hexString: "#F8DDA7", alpha: 0)!.cgColor]
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0);
        gradientLayer!.endPoint = CGPoint(x: 1, y: 0);
           //将gradientLayer作为子layer添加到主layer上
        self.theLayerView.layer.addSublayer(gradientLayer!)
    }
}
