//
//  SDInvitationCodeButton.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/3.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

import RxSwift
import RxCocoa


extension Reactive where Base: SDInvitationCodeButton {
    
    /// Reactive wrapper for `TouchUpInside` control event.
    internal var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}

class SDInvitationCodeButton: UIControl {
    private let rootFlexContainer: UIView = UIView();
    
    static let maxCount : Int = 60;
    
    lazy var theTipLabel: UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.systemFont(ofSize: 28)~
        theView.textColor = UIColor.white;
        theView.text = "发送验证码";
        theView.textAlignment = .center;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    
    private var currentCount: Int = -1 {
        didSet {
            if self.currentCount == -1 {
                self.theTipLabel.text = "发送验证码"
                self.isEnabled = true;
            } else if self.currentCount == 0 {
                self.theTipLabel.text = "重新发送"
                self.isEnabled = true;
            } else {
                self.theTipLabel.text = "\(self.currentCount)s";
                self.isEnabled = false;
            }
        }
    }
    
    private var startTime: Date?
    private var countDownTimer: Timer?
    
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
    
    public func requestInviteCodeFinish() {
        self.startTime = Date();
        self.currentCount = SDInvitationCodeButton.maxCount;
        self.startCountDownTime();
    }
    
    public func startCountDownTime() {
        if self.countDownTimer != nil {
            self.countDownTimer!.invalidate();
            self.countDownTimer = nil;
        }
        
        if self.startTime != nil {
            let endTime = Date().timeIntervalSince1970 - self.startTime!.timeIntervalSince1970;
            let count = floor(endTime / 1000);
            self.currentCount -= Int(count);
            if self.currentCount <= 0 {
                self.countDownTimer?.invalidate();
                self.countDownTimer = nil;
                self.startTime = nil;
            }
        }
        
        self.countDownTimer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {return}
            self.currentCount -= 1;
            log.debug("[倒计时] ---> \(self.currentCount)");
            if self.currentCount <= 0 {
                self.countDownTimer?.invalidate();
                self.countDownTimer = nil;
                self.startTime = nil;
            }
        }
    }
    deinit {
        if self.countDownTimer != nil {
            self.countDownTimer!.invalidate();
            self.countDownTimer = nil;
        }
    }
}
private extension SDInvitationCodeButton {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false
        self.rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theTipLabel);
        }
    }
}
