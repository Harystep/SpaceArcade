//
//  SDExchangeGlodSectionHeaderView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SPIndicator
protocol SDExchangeGoldDelegate : class {
    func onSureExchangeGoldByDiamon(_ num: Int);
}

class SDExchangeGlodSectionHeaderView: UICollectionReusableView {
    fileprivate let rootFlexContainer: UIView = UIView();
    
    weak var exchangeDelegate: SDExchangeGoldDelegate?
    
    lazy var theExchangeGoldView: SPExchangeGoldWithDiamondView = {
        let theView = SPExchangeGoldWithDiamondView()
        return theView;
    }()
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.white;
        theView.font = UIFont.boldSystemFont(ofSize: 36)~;
        theView.text = "能量转换太空币";
        return theView;
    }()
    init() {
        super.init(frame: CGRect.zero);
        self.configView();
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
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
    
    @objc func onSureExchange(_ sender: UIButton) {
        guard let inputNum = Int(self.theExchangeGoldView.theInputView.text!) else {
            SPIndicator.present(title: "请输入正确的钻石数", haptic: .error);

            return
        }
        self.exchangeDelegate?.onSureExchangeGoldByDiamon(inputNum)
    }
}

private extension SDExchangeGlodSectionHeaderView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theExchangeGoldView).width(690~).height(393~).alignSelf(.center);
            flex.addItem(self.theTitleLabel).marginTop(50~);
        }
        self.theExchangeGoldView.theSureExchangeButton.addTarget(self, action: #selector(onSureExchange(_:)), for: .touchUpInside);
    }
}
