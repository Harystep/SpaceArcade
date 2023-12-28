//
//  SDGameMoneyView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
import RxSwift
import RxCocoa

enum SDGameMoneyForType {
case moneyForCoin
    case moneyForPoint
}

class SDGameMoneyView: UIControl {
    fileprivate let rootFlexController = UIView();
    private let moneyType: SDGameMoneyForType;
    
    lazy var letUnitLogoImageView: UIImageView = {
        let theView = UIImageView.init();
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theValueLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.white;
        theView.font = UIFont.boldSystemFont(ofSize: 26)~;
        theView.text = "0"
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theAddImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_bt_add"))
        return theView;
    }()
    
    var moneyValue: String = "0" {
        didSet {
            self.theValueLabel.text = moneyValue;
            self.theValueLabel.flex.markDirty();
            setNeedsLayout();
        }
    }
    
    init(type: SDGameMoneyForType) {
        self.moneyType = type;
        super.init(frame: CGRectZero);
        self.configView();
    }
    
    override init(frame: CGRect) {
        self.moneyType = .moneyForCoin;
        super.init(frame: frame);
        self.configView();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().height(100%);
        self.rootFlexController.flex.layout(mode: .adjustWidth);
        self.rootFlexController.layer.masksToBounds = true;
        self.rootFlexController.layer.cornerRadius = 24~;
//        self.rootFlexController.layer.borderColor = UIColor(hex: 0x835939)!.cgColor;
//        self.rootFlexController.layer.borderWidth = 4~;
        self.rootFlexController.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        self.configData();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SDGameMoneyView {
    func configView(){
        self.addSubview(self.rootFlexController);
        self.rootFlexController.isUserInteractionEnabled = false;
        self.rootFlexController.flex.direction(.row).alignItems(.center).paddingRight(10~).define { [unowned self] flex in
            flex.addItem(self.letUnitLogoImageView).width(40~).height(40~).marginLeft(3~);
            flex.addItem(self.theValueLabel).marginLeft(8~).marginRight(16~);
            flex.addItem(self.theAddImageView).width(28~).height(28~);
        }
    }
    func configData() {
        if self.moneyType == .moneyForCoin {
            self.letUnitLogoImageView.image = UIImage(named: "space_coin_icon");
        } else {
            self.letUnitLogoImageView.image = UIImage(named: "space_energy_icon");
        }
    }
}
extension Reactive where Base: SDGameMoneyView {
    
    /// Bindable sink for `text` property.
    internal var moneyValue: Binder<String> {
        return Binder(self.base) { label, text in
            label.moneyValue = text;
        }
    }
    
    internal var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
