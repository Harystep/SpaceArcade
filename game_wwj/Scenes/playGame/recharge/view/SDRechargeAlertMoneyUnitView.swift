//
//  SDRechargeAlertMoneyUnitView.swift
//  game_wwj
//
//  Created by oneStep on 2023/7/7.
//

import Foundation
import FlexLayout
import PinLayout
import SwiftyFitsize
import SnapKit

enum SDUnitType {
    case bankForDiamond
    case bankForGoldCoin
    case bankForPoints
}

class SDRechargeAlertMoneyUnitView: UIControl {
    
    lazy var theBgImageView: UIImageView = {
        var inImage = UIImage(named: "ico_bank_unit_bg");
        let theView = UIImageView(image: inImage)
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    lazy var theLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.toZhenYan(size: 24)~;
        theView.textColor = UIColor.white;
        theView.text = "\(self.value)";
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theLogoImageView: UIImageView = {
        var logoImage : UIImage? = nil;
        switch self.bankType {
        case .bankForDiamond:
            logoImage = UIImage(named: "ico_bt_diamond");
            break
        case .bankForGoldCoin:
            logoImage = UIImage(named: "space_coin_icon");
            break
        case .bankForPoints:
            logoImage = UIImage(named: "space_energy_icon");
            break
        }
        let theView = UIImageView(image: logoImage);
        theView.contentMode = .scaleAspectFit;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    var showValue: String = "" {
        didSet {
            self.theLabel.text = self.showValue
        }
    }
    
    var value: Int = 0 {
        didSet {
            if self.value > 1000 {
                let valuePres = self.value % 1000;
                if valuePres > 0 {
                    self.showValue = String.init(format: "%.2fK", Float(self.value) * 1.0 / 1000)
                } else {
                    self.showValue = String.init(format: "%ldK", Int(self.value) / 1000)
                }
            } else if self.value > 1000000 {
                let valuePres = self.value % 10000;
                if valuePres > 0 {
                    self.showValue = String.init(format: "%.2fW", Float(self.value) * 1.0 / 10000)
                } else {
                    self.showValue = String.init(format: "%.2fW", Int(self.value) / 10000)
                }
            } else  {
                self.showValue = "\(self.value)";
            }
        }
    }
    
    let bankType: SDBankType
    let forBig: Bool;
    init(_ type: SDBankType, _ big: Bool = false) {
        bankType = type;
        forBig = big;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        
        
    }
}
private extension SDRechargeAlertMoneyUnitView {
    func configView() {

        self.addSubview(self.theBgImageView)
        self.addSubview(self.theLogoImageView)
        self.addSubview(self.theLabel)
        self.theBgImageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        self.theLogoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.snp_leadingMargin).offset(6)
            make.width.height.equalTo(20)
        }
        var marginX:Int = 10
        if self.bankType == .bankForPoints {
            marginX = 18
        }
        self.theLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.theLogoImageView).offset(-2)
            make.leading.equalTo(self.theLogoImageView.snp_trailingMargin).offset(marginX)
            make.trailing.equalTo(self.snp_trailingMargin).inset(10)
        }
    }
}
