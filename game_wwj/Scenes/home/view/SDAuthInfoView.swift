//
//  SDAuthInfoView.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/30.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

typealias SDAuthControllBlock = () -> Void;

class SDAuthInfoView: UIView {
    private let rootFlexContainer: UIView = UIView();
    
    var controllBlock: SDAuthControllBlock?
    
    lazy var theAvatarImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_default_avatar"));
        return theView;
    }()
    
    lazy var theNameLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        theView.text = "未登录";
        theView.textAlignment = .center;
        return theView;
    }()
    
    lazy var theLevelView: SPLevelProcessView = {
        let theView = SPLevelProcessView();
        theView.process = 0;
        theView.theProgressView.processValue = "";
        return theView;
    }()

    lazy var theTipLevelView: SDTipLevelInfoView = {
        let theView = SDTipLevelInfoView()
        theView.isHidden = true;
        return theView;
    }()
    
    lazy var theDiamondView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForDiamond, true);
        theView.value = 0;
        return theView;
    }()
    lazy var theGoldCoinView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForGoldCoin, true);
        theView.value = 0;
        return theView;
    }()
    lazy var thePointsView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForPoints, true);
        theView.value = 0;
        return theView;
    }()
    
    var authUserInfo: SDUser? {
        didSet {
            if authUserInfo != nil {
                self.theAvatarImageView.sd_setImage(with: URL.init(string: self.authUserInfo!.avatar), placeholderImage: UIImage(named: "ico_default_avatar"), context: nil);
                self.theNameLabel.text = self.authUserInfo!.nickname;
                if let money = Int(self.authUserInfo!.money) {
                    self.theDiamondView.value = money;
                } else {
                    self.theDiamondView.value = 0;
                }
                self.theGoldCoinView.value = self.authUserInfo!.goldCoin;
                self.thePointsView.value = self.authUserInfo!.points;
                if let memberLevel = self.authUserInfo!.memberLevelDto {
                    self.theLevelView.process = memberLevel.progress / 100.0
                    let levelImgName = "ico_level_\(memberLevel.level - 1)";
                    self.theLevelView.theLevelImageView.image = UIImage(named: levelImgName);

                    self.theLevelView.processValue = "\(String.init(format: "%.0f", memberLevel.progress * memberLevel.targetMoney))/\(String.init(format: "%.0f", memberLevel.targetMoney))"
                    
                    self.theLevelView.flex.markDirty();
                    self.theTipLevelView.isHidden = false;
                    self.theTipLevelView.tip = memberLevel.tips;
                    self.theTipLevelView.flex.markDirty();
                }
               
            } else {
                self.theLevelView.theLevelImageView.image = UIImage(named: "ico_not_sign");
                self.theNameLabel.text = "未登录";
                self.theAvatarImageView.image = UIImage(named: "ico_default_avatar");
                self.theDiamondView.value = 0;
                self.theGoldCoinView.value = 0
                self.thePointsView.value = 0;
                self.theLevelView.processValue = "";
            }
            self.rootFlexContainer.flex.layout();
        }
    }
    
    init() {
        super.init(frame: CGRect.zero);
        self.configView();
        self.authUserInfo = nil;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
        self.theAvatarImageView.layer.masksToBounds = true;
        self.theAvatarImageView.layer.cornerRadius = self.theAvatarImageView.frame.size.height / 2.0;
    }
}

private extension SDAuthInfoView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.direction(.row).define { [unowned self] flex in
            flex.addItem().marginLeft(30~).direction(.column).alignItems(.center).define { [unowned self] flex in
                flex.addItem(self.theAvatarImageView).width(120~).height(120~);
                flex.addItem(self.theNameLabel).marginTop(4~).width(120~);
            }
            flex.addItem().marginLeft(4~).direction(.column).define { [unowned self] flex in
                flex.addItem().direction(.row).define { [unowned self] flex in
                    flex.addItem(self.theLevelView).width(262~).height(72~);
                    flex.addItem(self.theTipLevelView).width(294~).height(48~).marginTop(18~).marginLeft(4~);
                }
                flex.addItem().direction(.row).marginTop(22~).define { [unowned self] flex in
                    if AppDefine.needDiamond {
                        flex.addItem(self.theDiamondView).height(62~).grow(1);
                    }
                    flex.addItem(self.theGoldCoinView).height(62~).grow(1);
                    flex.addItem(self.thePointsView).height(62~).grow(1);
                }
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTipUserInfoPress));
        tap.delegate = self;
        self.addGestureRecognizer(tap);
    }
    
    @objc func onTipUserInfoPress() {
        self.controllBlock?();
    }
}
extension SDAuthInfoView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = touch.view as? SDBankUnitView {
            return false;
        }
        return true;
    }
}
