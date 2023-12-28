//
//  SDBgImageButton.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/2.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

import RxSwift
import RxCocoa

extension Reactive where Base: SDBgImageButton {
    
    /// Reactive wrapper for `TouchUpInside` control event.
    internal var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
class SDBgImageButton: UIControl {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_btn_bg"))
        return theView;
    }()
    
    lazy var theBtTitleLabel : UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 36, weight: .medium)~;
        theView.textColor = UIColor.init(hexString: "#4936B8");
        theView.text = btTitle;
        return theView;
    }()
    let btTitle: String;
    init(_ title: String) {
        btTitle = title;
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
    }
}

private extension SDBgImageButton {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false;
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).alignItems(.center).justifyContent(.center).width(100%).height(100%).define { [unowned self] flex in
                flex.addItem(self.theBtTitleLabel).marginBottom(14~)
            }
        }
    }
}
