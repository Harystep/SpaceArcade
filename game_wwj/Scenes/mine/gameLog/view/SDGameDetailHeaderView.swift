//
//  SDGameDetailHeaderView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

class SDGameDetailHeaderView: UIView {
    fileprivate let rootFlexController = UIView();

    lazy var theCellView: SPGameDetailCell = {
        let theView = SPGameDetailCell(self.model)
        return theView;
    }()
    
    lazy var theSectionTitleLabel: UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.systemFont(ofSize: 36, weight: .bold)~;
        theView.textColor = UIColor.white;
        if model.originData.type == 1 {
            theView.text = "抓取记录";
        } else {
            theView.text = "结算记录";
        }
        return theView;
    }()
    
    var sectionTitle: String = "" {
        didSet {
            self.theSectionTitleLabel.text = self.sectionTitle;
            self.theSectionTitleLabel.flex.markDirty();
            self.rootFlexController.flex.layout();
        }
    }
    
    let model: SDGameLogItemModel;
    init(_ model: SDGameLogItemModel) {
        self.model = model;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.width(100%).height(100%).left().top();
        self.rootFlexController.flex.layout();
    }
}

private extension SDGameDetailHeaderView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.direction(.column).paddingTop(25~).define { [unowned self] flex in
            flex.addItem(self.theCellView).width(100%).height(220~);
            flex.addItem(self.theSectionTitleLabel).marginTop(50~).marginLeft(30~);
        }
    }
}
