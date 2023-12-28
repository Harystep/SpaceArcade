//
//  SDGameInFuncListView.swift
//  game_wwj
//
//  Created by sander shan on 2023/7/20.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

import RxSwift

enum SDFuncTag: Int {
    case recharge_func = 101
    case exchange_func = 102
    case rule_func = 103
    case settlement_func = 104
    case sound_func = 105
    case mute_func = 106
}

class SDGameInFuncListView: UIView {

    fileprivate let rootFlexController = UIView();
    
    let gameFuncTrigger : PublishSubject<SDFuncTag> = PublishSubject();
    
    lazy var theRechargeButton: SDInGameOtherFucButton = {
        let theView = SDInGameOtherFucButton(UIImage(named: "ico_game_recharge")!, "充值");
        theView.tag = 101;
        return theView;
    }()
    
    lazy var theExchangeButton: SDInGameOtherFucButton = {
        let theView = SDInGameOtherFucButton(UIImage(named: "ico_game_exchange")!, "兑换");
        theView.tag = 102;
        return theView;
    }()
    
    lazy var theRuleButton: SDInGameOtherFucButton = {
        let theView = SDInGameOtherFucButton(UIImage(named: "ico_game_rule")!, "玩法")
        theView.tag = 103;
        return theView;
    }()
    
    lazy var theSettlementButton: SDInGameOtherFucButton = {
        let theView = SDInGameOtherFucButton(UIImage(named: "ico_game_settlement")!, "结算");
        theView.tag = 104;
        return theView;
    }()
    
    lazy var theSoundButton: SDInGameOtherFucButton = {
        let theView = SDInGameOtherFucButton(UIImage.init(named: "ico_game_sound")!,UIImage.init(named: "ico_game_sound")!, "声音");
        theView.tag = 105;
        return theView;
    }()
    
    var gamingStatus: SDGamePlayStatus = .define {
        didSet {
            if self.gamingStatus == .selfPlaying {
                self.theSettlementButton.isHidden = false;
                self.theSettlementButton.flex.display(.flex);
                self.rootFlexController.flex.layout(mode: .adjustWidth)
            } else {
                self.theSettlementButton.isHidden = true;
                self.theSettlementButton.flex.display(.none);
                self.rootFlexController.flex.layout(mode: .adjustWidth)
            }
        }
    }
    
    
    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().height(100%);
        self.rootFlexController.flex.layout(mode: .adjustWidth);
    }
}
private extension SDGameInFuncListView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.direction(.row).define { [unowned self] flex in
            flex.addItem(self.theRechargeButton).width(84~).height(70~);
            flex.addItem(self.theExchangeButton).width(84~).height(70~);
            flex.addItem(self.theRuleButton).width(84~).height(70~);
            flex.addItem(self.theSettlementButton).width(84~).height(70~).display(.none);
            flex.addItem(self.theSoundButton).width(84~).height(70~);
        }
        
        self.theRechargeButton.addTarget(self, action: #selector(onTapFuncionItem(_:)), for: .touchUpInside);
        self.theExchangeButton.addTarget(self, action: #selector(onTapFuncionItem(_:)), for: .touchUpInside);
        self.theRuleButton.addTarget(self, action: #selector(onTapFuncionItem(_:)), for: .touchUpInside);
        self.theSettlementButton.addTarget(self, action: #selector(onTapFuncionItem(_:)), for: .touchUpInside);
        self.theSoundButton.addTarget(self, action: #selector(onTapFuncionItem(_:)), for: .touchUpInside);
    }
    
    @objc func onTapFuncionItem(_ sender: UIControl) {
        if sender.tag == SDFuncTag.sound_func.rawValue {
            if let button : SDInGameOtherFucButton = sender as? SDInGameOtherFucButton {
                button.isSelected = !button.isSelected;
                if button.isSelected {
                    self.gameFuncTrigger.onNext(SDFuncTag.mute_func);
                } else {
                    self.gameFuncTrigger.onNext(SDFuncTag.sound_func);
                }
            }
        }
        self.gameFuncTrigger.onNext(SDFuncTag(rawValue: sender.tag)!);
    }
}
