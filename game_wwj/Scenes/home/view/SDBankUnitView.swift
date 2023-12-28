//
//  SDBankUnitView.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/31.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

import RxSwift
import RxCocoa

enum SDBankType {
case bankForDiamond
    case bankForGoldCoin
    case bankForPoints
}

class SDBankUnitView: UIControl {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theBgImageView: UIImageView = {
        var inImage = UIImage(named: "ico_bank_unit_bg");
        if self.forBig {
            inImage = UIImage(named: "ico_bank_unit_mine_bg");
        }
//        let insert = UIEdgeInsets(top: 28~, left: 91~, bottom: 34~, right: 91~);
//
//        inImage = inImage?.resizableImage(withCapInsets: insert);
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
        theView.textAlignment = .center
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
            self.theLabel.text = self.showValue;
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
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
    }
}

extension Reactive where Base: SDBankUnitView {
    
    /// Reactive wrapper for `TouchUpInside` control event.
    internal var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}

private extension SDBankUnitView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false;
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).direction(.row).paddingLeft(12~).paddingRight(18~).paddingBottom(8~).alignItems(.center).justifyContent(.spaceBetween).width(100%).height(100%).define { [unowned self] flex in
                flex.addItem().direction(.row).define { [unowned self] flex in
                    flex.addItem(self.theLogoImageView).width(36~).height(36~);
                    flex.addItem(self.theLabel).padding(8~)
                }
            }
        }
        
        self.addTarget(self, action: #selector(onTapTrigger(_:)), for: .touchUpInside);
    }
    
    @objc func onTapTrigger(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "topBankTrigger"), object: self.bankType);
    }
}
