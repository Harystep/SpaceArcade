//
//  SPGameDetailCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
import SDWebImage
class SPGameDetailCell: UIView {
    fileprivate let rootFlexController = UIView();
    
    fileprivate let rootLayoutView = UIView();
    
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_game_log_bg"))
        return theView;
    }()
    
    lazy var theImageView: UIImageView = {
        let theView = UIImageView.init();
        theView.contentMode = .scaleToFill;
        return theView;
    }()
    lazy var theCellTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30, weight: .medium)~
        theView.textColor = UIColor.white;
        return theView;
    }()
    lazy var theCellTimeLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    lazy var theCellStatusLabel : UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    let model: SDGameLogItemModel;
    
    init(_ model: SDGameLogItemModel) {
        self.model = model;
        super.init(frame: CGRect.zero);
        self.configView();
        self.configData();
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

private extension SPGameDetailCell {
    func configView() {
        self.backgroundColor = UIColor.clear;
        
        self.addSubview(self.rootFlexController);
        
        self.rootFlexController.flex.paddingTop(24~).alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(690~).height(196~).direction(.row).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().direction(.row).marginLeft(20~).marginTop(22~).height(142~).alignItems(.center).define { [unowned self]  flex in
                    flex.addItem(self.theImageView).width(160~).height(142~);
                    flex.addItem().marginLeft(20~).direction(.column).justifyContent(.center).define { [unowned self] flex in
                        flex.addItem(self.theCellTitleLabel).grow(1);
                        flex.addItem(self.theCellTimeLabel).marginTop(10~).width(300~)
                        flex.addItem(self.theCellStatusLabel).marginTop(10~)
                    }
                }
            }
        }
        
        log.debug("[SDGameLogItemTableViewCell] ----> configView")
    }
    func configData() {
        self.theImageView.sd_setImage(with: URL(string: model.imgUrl));
        self.theCellTitleLabel.text = model.logTitle;
        self.theCellTimeLabel.text = model.logTime;
        self.theCellStatusLabel.attributedText = model.logResult;
    }
}
