//
//  SPMemberTopInfoView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/4.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

import SDWebImage

import RxSwift

class SPMemberTopInfoView: UIView {
    private let rootFlexContainer: UIView = UIView();
    
    
    lazy var theAvatarControl: UIControl = {
        let theView = UIControl();
        return theView;
    }()
    
    lazy var theInputNameControl: UIControl = {
        let theView = UIControl();
        return theView;
    }()
    
    lazy var theAvatarImageView: UIImageView = {
        let theView = UIImageView.init(image: UIImage(named: "ico_default_avatar"));
        return theView;
    }()
    
    lazy var theNameLabel : UILabel = {
        let theView = UILabel.init()
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 32, weight: .medium)~;
        theView.text = "你的名称";
        return theView;
    }()
    lazy var theInputEditImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_edit_input"))
        return theView;
    }()
    lazy var theIdLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 32, weight: .medium)~;
        theView.text = "";
        return theView;
    }()
    lazy var theDiamondView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForDiamond, true);
        return theView;
    }()
    lazy var theGoldCoinView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForGoldCoin, true);
        return theView;
    }()
    lazy var thePointsView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForPoints, true);
        return theView;
    }()
    
    let tapAvatarTrigger : PublishSubject<Void> = PublishSubject();
    let tapInputNameTrigger: PublishSubject<Void> = PublishSubject();
    
    var authUserInfo: SDUser? {
        didSet {
            if authUserInfo != nil {
                self.theAvatarImageView.sd_setImage(with: URL.init(string: self.authUserInfo!.avatar), placeholderImage: UIImage(named: "ico_default_avatar"), context: nil);
                self.theNameLabel.text = self.authUserInfo!.nickname;
                self.theNameLabel.flex.markDirty()
                self.theIdLabel.text = "ID:\(self.authUserInfo!.memberId ?? 0)"
                self.theIdLabel.flex.markDirty();
                if let money = Int(self.authUserInfo!.money) {
                    self.theDiamondView.value = money;
                } else {
                    self.theDiamondView.value = 0;
                }
                self.theGoldCoinView.value = self.authUserInfo!.goldCoin;
                self.thePointsView.value = self.authUserInfo!.points
                self.rootFlexContainer.flex.layout();
            } else {
                self.theAvatarImageView.image = UIImage(named: "ico_default_avatar");
                self.theIdLabel.text = "";
                self.theNameLabel.text = "未登录";
                self.theDiamondView.value = 0;
                self.theGoldCoinView.value = 0;
                self.thePointsView.value = 0;
                self.theNameLabel.flex.markDirty()
                self.theIdLabel.flex.markDirty();
                self.rootFlexContainer.flex.layout();

            }
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
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
        self.theAvatarImageView.layer.masksToBounds = true;
        self.theAvatarImageView.layer.cornerRadius = self.theAvatarImageView.frame.size.height / 2.0;
    }
}
private extension SPMemberTopInfoView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.direction(.column).define { [unowned self] flex in
            flex.addItem(self.theAvatarControl).alignSelf(.center).width(120~).height(120~).define { [unowned self] flex in
                flex.addItem(self.theAvatarImageView).width(120~).height(120~);
            }
            flex.addItem(self.theInputNameControl).direction(.row).marginTop(12~).alignItems(.center).alignSelf(.center).define { [unowned self] flex in
                flex.addItem(self.theNameLabel);
                flex.addItem(self.theInputEditImageView).width(36~).height(36~);
            }
            flex.addItem(self.theIdLabel).alignSelf(.center).marginTop(2~);
            
            flex.addItem().direction(.row).alignItems(.center).marginHorizontal(30~).marginTop(30~).define { [unowned self] flex in
                if AppDefine.needDiamond {
                    flex.addItem(self.theDiamondView).height(62~).grow(1);
                    flex.addItem(self.theGoldCoinView).height(62~).grow(1).marginLeft(24~);
                } else {
                    flex.addItem(self.theGoldCoinView).height(62~).grow(1)
                }

                flex.addItem(self.thePointsView).height(62~).grow(1).marginLeft(24~);
            }
        }
        self.theAvatarControl.addTarget(self, action: #selector(onTapAvatarView(_:)), for: .touchUpInside)
        self.theInputNameControl.addTarget(self, action: #selector(onTapInputNameView(_:)), for: .touchUpInside);
    }
    
    @objc func onTapAvatarView(_ sender: UIControl) {
        self.tapAvatarTrigger.onNext(());
    }
    
    @objc func onTapInputNameView(_ sender: UIControl) {
        self.tapInputNameTrigger.onNext(());
    }
}
