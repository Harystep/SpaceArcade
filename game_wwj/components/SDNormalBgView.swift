//
//  SDNormalBgView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/8.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

class SDNormalBgView: UIView {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var thebgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_home_bg"));
        return theView;
    }()
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
    }
}

private extension SDNormalBgView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.thebgImageView).position(.absolute).width(100%).height(100%)
        }
    }
}
