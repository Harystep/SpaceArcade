//
//  SPLevelProcessView.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/31.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SPLevelProcessView: UIView {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theLevelImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_not_sign"));
        return theView;
    }()
    
    lazy var theProgressView: SPLevelProcessBgView = {
        let theView = SPLevelProcessBgView();
        return theView;
    }()

    var process: Float = 0 {
        didSet {
            self.theProgressView.process = process;
            self.theProgressView.flex.markDirty();
            self.rootFlexContainer.flex.layout();
        }
    }
    var processValue: String = "" {
        didSet {
            self.theProgressView.processValue = processValue;
            self.theProgressView.flex.markDirty();
            self.rootFlexContainer.flex.layout();
        }
    }
    init() {
        super.init(frame: CGRect.zero)
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

private extension SPLevelProcessView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theProgressView).width(234~).height(64~).position(.absolute).bottom(0).right(0);
            flex.addItem(self.theLevelImageView).width(78~).height(74~);
        }
    }
}
