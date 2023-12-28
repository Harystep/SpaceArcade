//
//  SDGameFuncGuidButton.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/1.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize


enum SDGameGuidType {
case GuidForNew
    case GuidForInvite
    case GuidForSign
    case GuidForKefu
}

class SDGameFuncGuidButton: UIControl {
    private let rootFlexContainer: UIView = UIView();

    
    lazy var theBgImageView: UIImageView = {
        var image : UIImage? = nil;
        switch guidType {
        case .GuidForNew:
            image = UIImage(named: "ico_guid_1")
            break
        case .GuidForInvite:
            image = UIImage(named: "ico_guid_2")
            break
        case .GuidForSign:
            image = UIImage(named: "ico_guid_3")
            break
        case .GuidForKefu:
            image = UIImage(named: "ico_guid_4")
            break
        }
        let theView = UIImageView(image: image);
        return theView;
    }()
    lazy var theTipLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 32)~;
        theView.textColor = UIColor.white;
        switch guidType {
        case .GuidForNew:
            theView.text = "新手指导";
            break
        case .GuidForInvite:
            theView.text = "邀请有礼";
            break
        case .GuidForSign:
            theView.text = "签到";
            break
        case .GuidForKefu:
            theView.text = "在线客服";
            break
        }
        return theView;
    }()
    
    lazy var theCheckLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 24, weight: .medium)~;
        theView.textColor = UIColor.white;
        theView.text = "点击查看";
        return theView;
    }()
    
    lazy var theNextImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_next_right"))
        return theView;
    }()
    
    let guidType: SDGameGuidType;
    init(_ type: SDGameGuidType) {
        guidType = type;
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

private extension SDGameFuncGuidButton {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false;
        self.rootFlexContainer.flex.define { flex in
            flex.addItem(self.theBgImageView).width(100%).height(100%).define { [unowned self] flex in
                flex.addItem(self.theTipLabel).marginLeft(22~).marginTop(24~);
                flex.addItem().direction(.row).alignItems(.center).marginLeft(22~).marginTop(4~).define {  [unowned self]  flex in
                    flex.addItem(self.theCheckLabel);
                    flex.addItem(self.theNextImageView).width(10~).height(16~).marginLeft(6~)
                }
            }
        }
    }
}
