//
//  SPLevelProcessBgView.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/31.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SPLevelProcessBgView: UIView {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_progress_bg"));
        return theView;
    }()
    
    lazy var theProgressView: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theProgreeeLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.toZhenYan(size: 28)~
        theView.textColor = UIColor.white;
        theView.textAlignment = .center;
        theView.text = "0/100000";
        return theView;
    }()
    
    var gradientLayer: CAGradientLayer?
    
    var process: Float = 0 {
        didSet {
            let screenWidth = self.frame.size.width - 24~;
            self.theProgressView.flex.width(screenWidth * CGFloat(process));
            self.rootFlexContainer.flex.layout();
        }
    }
    
    var processValue: String = "" {
        didSet {
            self.theProgreeeLabel.text = processValue;
            self.theProgressView.flex.markDirty();
            self.rootFlexContainer.flex.layout();
        }
    }

    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
        self.gradientLayer!.frame = self.theProgressView.bounds;
        self.theProgressView.layer.masksToBounds = true;
        self.theProgressView.layer.cornerRadius = 20~;
    }
}
private extension SPLevelProcessBgView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).width(100%).height(100%).padding(8~, 8~, 16~, 16~).justifyContent(.center).alignItems(.center).define { flex in
                flex.addItem(self.theProgressView).position(.absolute).top(8~).left(8~).height(40~).width(40%);
                flex.addItem(self.theProgreeeLabel);
            }
        }
        gradientLayer = CAGradientLayer()
           //设置渐变的主颜色
        gradientLayer!.colors = [UIColor.init(hexString: "#F7D553")!.cgColor, UIColor.init(hexString: "#EDAA29")!.cgColor]
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0);
        gradientLayer!.endPoint = CGPoint(x: 1, y: 0);
           //将gradientLayer作为子layer添加到主layer上
        self.theProgressView.layer.addSublayer(gradientLayer!)
    }
}
