//
//  SDSignUnitView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SDSignUnitView: UIControl {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView()
        theView.contentMode = .scaleAspectFit;
        return theView;
    }()
    
    lazy var theDayTitleLabel : UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.toZhenYan(size: 30)~;
        return theView;
    }()
    
    lazy var theLogoImageView: UIImageView = {
        let theView = UIImageView();
        return theView;
    }()
    
    lazy var theValueLabel : UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 30~);
        return theView;
    }()
    
    lazy var theHadSignMaskView: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.init(hex: 0x080808, alpha: 0.8);
        theView.layer.cornerRadius = 18~;
        return theView;
    }()
    
    lazy var theSignRightView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_sign_right"))
        return theView;
    }()
    
    lazy var theSignRightLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 30)~
        theView.textColor = UIColor.init(hex: 0xFFE0A4);
        theView.text = "已签到";
        return theView;
    }()
    
    let dayIndex: Int
    let signData: SDSignData;
    init(_ index: Int, _ data : SDSignData) {
        self.dayIndex = index;
        self.signData = data;
        
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
    }
    
    func sendSign() {
        self.theHadSignMaskView.isHidden = false;        
    }
}
private extension SDSignUnitView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false;
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
            flex.addItem(self.theDayTitleLabel).marginTop(18~).alignSelf(.center);
            if self.dayIndex == 6 {
                flex.addItem(self.theLogoImageView).width(102~).height(86~).alignSelf(.center).marginTop(8~);
                flex.addItem(self.theValueLabel).alignSelf(.center).marginTop(2~);
            } else {
                flex.addItem(self.theLogoImageView).width(106~).height(96~).marginTop(20~).alignSelf(.center)
                flex.addItem(self.theValueLabel).marginTop(10~).alignSelf(.center);
            }
            flex.addItem(self.theHadSignMaskView).justifyContent(.center).alignItems(.center).position(.absolute).width(100%).height(100%).define { [unowned self]  flex in
                flex.addItem(self.theSignRightView).width(62~).height(50~);
                flex.addItem(self.theSignRightLabel);
            }
        }
        
        self.theDayTitleLabel.text = "第\(self.dayIndex + 1)天";
        
        if self.signData.type == 1 {
            self.theBgImageView.image = UIImage(named: "ico_sign_day_blue_bg");
            self.theLogoImageView.image = UIImage(named: "ico_sign_logo");
            self.theDayTitleLabel.textColor = UIColor.init(hex: 0x0370B8);
            self.theValueLabel.textColor = UIColor.init(hex: 0x98DEFF);
        } else {
            self.theBgImageView.image = UIImage(named: "ico_sign_day_red_bg");
            self.theDayTitleLabel.textColor = UIColor.init(hex: 0xFF6D01);
            if self.signData.type == 2 {
                self.theLogoImageView.image = UIImage(named: "space_energy_icon");
            } else {
                self.theLogoImageView.image = UIImage(named: "space_coin_icon");
            }
            self.theValueLabel.textColor = UIColor.init(hex: 0xFFEB7E);
        }
        if self.dayIndex == 6 {
            self.theBgImageView.image = UIImage(named: "ico_sign_day_7");
        }
        
        self.theValueLabel.text = "\(self.signData.points)\(self.signData.type == 1 ? "钻石" : self.signData.type == 2 ? "能量" : "太空币")"
        
        self.theHadSignMaskView.isHidden = self.signData.status == 1
    }
}
