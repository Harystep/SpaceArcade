//
//  SDGameTagView.swift
//  game_wwj
//
//  Created by sander shan on 2023/8/21.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

class SDGameTagView: UIView {
    fileprivate let rootFlexController = UIView();
    
    lazy var theGameTagLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 24)~;
        return theView;
    }()
    
    var gameTag: Int = 0 {
        didSet {
            self.theGameTagLabel.text = "\(gameTag)";
    
            self.theGameTagLabel.flex.markDirty();
            self.rootFlexController.flex.layout();
        }
    }

    init() {
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().height(100%);
        self.rootFlexController.flex.layout();
    }
    
}

private extension SDGameTagView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.border(1, UIColor.white).define { [unowned self] flex in
            flex.addItem(self.theGameTagLabel);
        }
    }
}
