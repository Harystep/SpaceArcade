//
//  SDSettlementResultAlertContentView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/22.
//

import FlexLayout
import PinLayout
import SwiftHEXColors
import SwiftyFitsize
import UIKit

class SDSettlementResultAlertContentView: UIView {
    fileprivate let rootFlexController = UIView()
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel()
        theView.font = UIFont.boldSystemFont(ofSize: 30)~
        theView.textColor = UIColor.black
        return theView
    }()
    
    lazy var theMessageLabel: UILabel = {
        let theView = UILabel()
        theView.font = UIFont.systemFont(ofSize: 26)~
        theView.textColor = UIColor(hex: 0x444444)
        return theView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let theView = UIActivityIndicatorView()
        return theView
    }()

    init() {
        super.init(frame: CGRectZero)
        self.configView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.rootFlexController.pin.left().top().width(100%).height(100%)
        self.rootFlexController.flex.layout()
    }
}

private extension SDSettlementResultAlertContentView {
    func configView() {
        self.addSubview(self.rootFlexController)
        self.rootFlexController.flex
            .direction(.column)
            .alignItems(.center)
            .define { [unowned self] flex in
                flex.addItem(self.theTitleLabel);
                flex.addItem(self.theMessageLabel).marginTop(30~);
            }
    }
}
