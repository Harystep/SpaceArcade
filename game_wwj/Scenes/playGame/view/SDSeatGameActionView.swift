//
//  SDSeatGameActionView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/21.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

import RxCocoa
import RxSwift

class SDSeatGameActionView: UIView {
    fileprivate let rootFlexController = UIView();
    
    // MARK: - UI
    lazy var thePushCoinBt: SDButton = {
        let theView = SDButton.init()
        theView.setImage(UIImage(named: "ico_push_coin"), for: .normal);
        theView.tag = 1;
        theView.imageView?.contentMode = .scaleAspectFit
        return theView;
    }()
    
    lazy var theDoubleBt:  SDButton = {
        let theView = SDButton.init()
        theView.setImage(UIImage(named: "ico_double"), for: .normal);
        theView.imageView?.contentMode = .scaleAspectFit
        return theView;
    }()
    
    lazy var theFireBt: SDButton = {
        let theView = SDButton.init();
        theView.setImage(UIImage(named: "ico_fire"), for: .normal);
        theView.imageView?.contentMode = .scaleAspectFit
        return theView;
    }()
    
    lazy var thePushMultipleView: UIView = {
        let theView = UIView.init()
        theView.isHidden = true;
        return theView;
    }()
    
    lazy var thePushCoin5Bt: SDButton = {
        let theView = SDButton.init();
        theView.setImage(UIImage(named: "ico_push_5"), for: .normal);
        theView.imageView?.contentMode = .scaleAspectFit
        theView.tag = 5;
        return theView;
    }()
    
    lazy var thePushCoint10Bt: SDButton = {
        let theView = SDButton.init();
        theView.setImage(UIImage(named: "ico_push_10"), for: .normal);
        theView.imageView?.contentMode = .scaleAspectFit
        theView.tag = 10;
        return theView;
    }()
    
    lazy var thePushCoint20Bt: SDButton = {
        let theView = SDButton.init();
        theView.setImage(UIImage(named: "ico_push_20"), for: .normal);
        theView.imageView?.contentMode = .scaleAspectFit
        theView.tag = 20;
        return theView;
    }()
    
    // MARK: - ViewModel
    
    let touchPushCoinTrigger: PublishSubject<Int> = PublishSubject<Int>();
    let touchDoubleTrigger: PublishSubject<Void> = PublishSubject<Void>();
    let touchFireTrigger: PublishSubject<Void> = PublishSubject<Void>();
    let touchFireBeganTrigger: PublishSubject<Void> = PublishSubject<Void>();
    let touchFireEndTrigger: PublishSubject<Void> = PublishSubject<Void>();
    
    var hadTouchBeganFire: Bool = false;
    
    
    init() {
        super.init(frame: CGRect.zero);
        self.configView();
        self.configData();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.configView();
        self.configData();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().right().width(100%).height(100%);
        self.rootFlexController.flex.layout();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SDSeatGameActionView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.direction(.column).alignItems(.end).define { [unowned self] flex in
            flex.addItem(self.thePushCoinBt).width(90~).height(90~).marginTop(97~).marginLeft(102~);
            flex.addItem(self.theDoubleBt).width(90~).height(90~).marginTop(26~).marginLeft(102~);
            flex.addItem(self.theFireBt).width(185~).height(185~).marginTop(48~);
            flex.addItem(self.thePushMultipleView).backgroundColor(UIColor.init(white: 0, alpha: 0.4)).cornerRadius(45~).position(.absolute).left(0).top(0).paddingTop(5~).paddingBottom(5~).direction(.column).justifyContent(.spaceBetween).width(90~).height(290~).define {  [unowned self] flex in
                flex.addItem(self.thePushCoin5Bt).width(90~).height(90~)
                flex.addItem(self.thePushCoint10Bt).width(90~).height(90~)
                flex.addItem(self.thePushCoint20Bt).width(90~).height(90~)
            }
        }
    }
    func configData() {
        self.thePushCoinBt.addTarget(self, action: #selector(onPushCoinPress(_: )), for: .touchUpInside);
        self.thePushCoin5Bt.addTarget(self, action: #selector(onPushCoinPress(_: )), for: .touchUpInside);
        self.thePushCoint10Bt.addTarget(self, action: #selector(onPushCoinPress(_: )), for: .touchUpInside);
        self.thePushCoint20Bt.addTarget(self, action: #selector(onPushCoinPress(_: )), for: .touchUpInside);
        
        self.theDoubleBt.addTarget(self, action: #selector(onDoublePress(_:)), for: .touchUpInside);
        
        self.theFireBt.addTarget(self, action: #selector(onFirePress(_: )), for: .touchUpInside);
        self.theFireBt.addTarget(self, action: #selector(onFirePress(_: )), for: .touchCancel);
        self.theFireBt.addTarget(self, action: #selector(onFirePress(_: )), for: .touchUpOutside);
        self.theFireBt.addTarget(self, action: #selector(onFireBeginPress(_ :)), for: .touchDown);
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPushCoinTap(_:)));
        longTap.minimumPressDuration = 1;
        self.thePushCoinBt.addGestureRecognizer(longTap);
    }
    @objc func onPushCoinPress(_ sender: UIControl) {
        self.touchPushCoinTrigger.onNext(sender.tag);
        self.thePushMultipleView.isHidden = true;
    }
    @objc func onDoublePress(_ sender: UIControl) {
        self.touchDoubleTrigger.onNext(());
    }
    @objc func onFirePress(_ sender: UIControl) {
        log.debug("[onFirePress] -----> ");
        if self.hadTouchBeganFire {
            NSObject.cancelPreviousPerformRequests(withTarget: self);
            self.touchFireTrigger.onNext(());
        } else {
            self.touchFireEndTrigger.onNext(());
        }
    }
    @objc func onFireBeginPress(_ sender: UIControl) {
        log.debug("[onFireBeginPress] -----> ")
        self.hadTouchBeganFire = true;
        self.perform(#selector(delayFire), with: self, afterDelay: 0.2);
    }
    @objc func delayFire() {
        self.hadTouchBeganFire = false;
        self.touchFireBeganTrigger.onNext(());
    }
    
    @objc func onLongPushCoinTap(_ gesture: UIGestureRecognizer) {
        log.debug("[tap] ----> long");
        
        self.thePushMultipleView.isHidden = false;
        
    }
}
