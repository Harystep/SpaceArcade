//
//  SDGameAlertViewController.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/22.
//

import UIKit

import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

protocol SDGameAlertViewControllerType {
    func updateAlert(_ title: String, _ message: String);
}

protocol SDGameAlertEventDelegate: class {
    func onSureAlert(alert: SDGameAlertViewController, eventType: SDGameAlertEventType);
}

enum SDGameAlertEventType {
    /// 退出 alert
    case alertForExit
    /// 退出之前 需要 先结算
    case alertForExitAndSettlement
    /// 结算 alert
    case alertForSettlement
    /// 结算结果 alert
    case alertForSettlementResult
    /// 结算结果 然后退出
    case alertForSettlementResultAndExit
    
    case alertForContentView
}

class SDGameAlertViewController: UIViewController {
    
    fileprivate let rootFlexController = UIView()
    
    lazy var theAlertBgView: UIImageView = {
        let theView = UIImageView.init()
//        theView.backgroundColor = UIColor.init(hex: 0xF8F09B);
        theView.image = UIImage(named: "push_pay_fail")
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 20~;
        theView.isUserInteractionEnabled = true
        return theView;
    }()
    
    lazy var theAlertContentView: UIView = {
        let theView = UIView.init();
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 10~;
        return theView;
    }()
    
    lazy var theSureButton: UIButton = {
        let theView = UIButton.init();
        theView.setTitle("确定", for: .normal);
        theView.setTitleColor(UIColor.white, for: .normal);
        theView.backgroundColor = UIColor.init(hex: 0xEEAA29);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 10~;
        return theView;
    }()
    
    lazy var thePointView1: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.init(hex: 0xF8F09B);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 7~;
        return theView;
    }()
    lazy var thePointView2: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.init(hex: 0xF8F09B);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 7~;
        return theView;
    }()
    lazy var thePointView3: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.init(hex: 0xF8F09B);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 7~;
        return theView;
    }()
    lazy var thePointView4: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor.init(hex: 0xF8F09B);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 7~;
        return theView;
    }()
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var theMessageLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 26)~
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var theCloseButton: SDRedCloseView = {
        let theView = SDRedCloseView()
        return theView;
    }()
    
    let alertContentView: UIView?
    
    weak var alertDelegate: SDGameAlertEventDelegate?
    
    let alertEventType: SDGameAlertEventType
    init(eventType: SDGameAlertEventType, view: UIView? = nil) {
        alertContentView = view;
        alertEventType = eventType;
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%);
        if (self.alertEventType == .alertForSettlementResult) {
            self.theAlertBgView.flex.height(280~);
        }
        if self.alertEventType == .alertForContentView {
            self.theAlertContentView.flex.height(312~);
        }
        self.rootFlexController.flex.layout();
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false;
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape;
        }
    }
}

private extension SDGameAlertViewController {
    func configView() {
        self.view.addSubview(self.rootFlexController);
        
        self.rootFlexController.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem().padding(30~).define { [unowned self] flex in
                flex.addItem(self.theAlertBgView).width(628~).height(360~).direction(.column).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theAlertContentView).direction(.column).justifyContent(.center).alignItems(.center).width(580~).height(180~).marginTop(24~).define { [unowned self] flex in
                        flex.addItem(self.thePointView1).width(14~).height(14~).position(.absolute).left(10~).top(10~);
                        flex.addItem(self.thePointView2).width(14~).height(14~).position(.absolute).right(10~).top(10~);
                        flex.addItem(self.thePointView3).width(14~).height(14~).position(.absolute).left(10~).bottom(10~);
                        flex.addItem(self.thePointView4).width(14~).height(14~).position(.absolute).right(10~).bottom(10~);
                        if self.alertContentView != nil {
                            flex.addItem(self.alertContentView!).width(100%).height(100%);
                        } else {
                            flex.addItem(self.theTitleLabel);
                            flex.addItem(self.theMessageLabel).marginTop(30~);
                        }
                    }
                    if (self.alertEventType != .alertForSettlementResult && self.alertEventType != .alertForContentView) {
                        flex.addItem().grow(1).justifyContent(.center).alignItems(.center).define {  [unowned self]  flex in
                            flex.addItem(self.theSureButton).width(278~).height(84~);
                        }
                    }
                }
                flex.addItem(self.theCloseButton).width(60~).height(40~).position(.absolute).right(0).top(0);
            }
        }
    }
    func configData() {
        self.theSureButton.addTarget(self, action: #selector(onSurePress), for: .touchUpInside);
        self.theCloseButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside);
    }
    
    @objc func onSurePress() {
        self.dismiss(animated: false);
        if self.alertDelegate != nil {
            self.alertDelegate?.onSureAlert(alert: self, eventType: self.alertEventType);
        }
    }
    @objc func dismissViewController() {
        self.dismiss(animated: false);
    }
}

extension SDGameAlertViewController: SDGameAlertViewControllerType {
    func updateAlert(_ title: String, _ message: String) {
        self.theTitleLabel.text = title;
        self.theMessageLabel.text = message;
        self.theTitleLabel.flex.markDirty();
        self.theMessageLabel.flex.markDirty();
        self.view.setNeedsLayout();
    }
}

extension SDGameAlertViewController: UIGestureRecognizerDelegate {
    
}
