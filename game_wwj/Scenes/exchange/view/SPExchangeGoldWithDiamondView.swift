//
//  SPExchangeGoldWithDiamondView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SPExchangeGoldWithDiamondView: UIView {

    fileprivate let rootFlexContainer: UIView = UIView();
    
    lazy var theBgView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_exchange_diamond_glod_bg"))
        return theView;
    }()
    
    lazy var theInputBgView: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.white;
        theView.layer.cornerRadius = 10~;
        theView.layer.masksToBounds = true;
        return theView;
    }()
    
    lazy var theInputView: UITextField = {
        let theView = UITextField.init()
        theView.placeholder = "1钻石可兑换10太空币";
        theView.font = UIFont.boldSystemFont(ofSize: 36)~
        theView.keyboardType = .numberPad;
        return theView;
    }()
    
    lazy var theSureExchangeButton: UIButton = {
        let theView = UIButton.init()
        theView.setBackgroundImage(UIImage(named: "ico_exchange_btn"), for: .normal);
        return theView;
    }()

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
    }
    
}
private extension SPExchangeGoldWithDiamondView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.direction(.column).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%);
            flex.addItem(self.theInputBgView).width(630~).height(98~).marginTop(166~).define { [unowned self] flex in
                flex.addItem(self.theInputView).width(100%).height(100%).marginHorizontal(30~);
            }
            flex.addItem(self.theSureExchangeButton).width(346~).height(88~).marginTop(30~);
        }
    }
}
