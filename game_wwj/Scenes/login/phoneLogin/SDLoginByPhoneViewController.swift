//
//  SDLoginByPhoneViewController.swift
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

import MBProgressHUD

class SDLoginByPhoneViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    
    lazy var theLoginPhoneBgView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_login_phone_bg"))
        return theView;
    }()
    
    lazy var theLoginTipLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 36, weight: .medium)~;
        theView.text = "手机号验证码登录";
        return theView;
    }()
    
    lazy var theCloseButton : UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage(named: "ico_white_close"), for: .normal);
        return theView;
    }()
    
    lazy var theAccountLogoImageView: UIImageView = {
        let theView = UIImageView.init(image: UIImage(named: "ico_account"));
        return theView;
    }()
    
    lazy var thePassworldLogoImageView: UIImageView = {
        let theView = UIImageView.init(image: UIImage(named: "ico_password"));
        return theView;
    }()
    
    lazy var theInputAccountView: UITextField = {
        let theView = UITextField.init();
        theView.placeholder = "请输入账号";
        theView.font = UIFont.systemFont(ofSize: 32)~;
        return theView;
    }()
    
    lazy var theInputPasswordView: UITextField = {
        let theView = UITextField.init()
        theView.placeholder = "请输入验证码";
        theView.font = UIFont.systemFont(ofSize: 32)~;
        theView.keyboardType = .numbersAndPunctuation;
        return theView;
    }()
    
    lazy var theInviteCodeButton: SDInvitationCodeButton = {
        let theView = SDInvitationCodeButton()
        return theView;
    }()
    
    lazy var theLoginButton: SDBgImageButton = {
        let theView = SDBgImageButton("登录");
        return theView;
    }()
    init() {
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.rootFlexContainer.flex.paddingTop(self.view.safeAreaInsets.top).paddingBottom(self.view.safeAreaInsets.bottom).layout()
        
        self.rootFlexContainer.backgroundColor = UIColor.init(white: 0, alpha: 0.88);
    }
    
    typealias ViewModel = SDLoginByPhoneViewModel;
    var viewModel: Attachable<SDLoginByPhoneViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDLoginByPhoneViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SDLoginByPhoneViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            cancelTaps: theCloseButton.rx.tap.asDriver(),
            didInviteCode: theInviteCodeButton.rx.tap.asDriver(),
            accountMobile: theInputAccountView.rx.text.orEmpty.asDriver(),
            invitedCode: theInputPasswordView.rx.text.orEmpty.asDriver(),
            didLoginTap: theLoginButton.rx.tap.asDriver()
        )
    }();
    func bind(viewModel: SDLoginByPhoneViewModel) -> SDLoginByPhoneViewModel {
        viewModel.invitedCodeResult.asObservable().filter({ result in
            return result;
        }).subscribe(onNext: { [unowned self] result in
            self.theInviteCodeButton.requestInviteCodeFinish();
        }).disposed(by: disposeBag);
        viewModel.isInviatedCodeValid.drive(self.theInviteCodeButton.rx.isHidden).disposed(by: disposeBag);
        viewModel.isActionLoginValid.drive(self.theLoginButton.rx.isEnabled).disposed(by: disposeBag);
        
        viewModel.loggingIn.asObservable().subscribe(onNext: { [weak self] loginStatus in
            log.debug("[loggedIn] ----> \(loginStatus)");
            guard let self = self else { return }
            if loginStatus {
                MBProgressHUD.showAdded(to: self.view, animated: true);
            } else {
                MBProgressHUD.hide(for: self.view, animated: true);
            }
        }).disposed(by: disposeBag)
        
        return viewModel;
    }
}
private extension SDLoginByPhoneViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.alignItems(.center).justifyContent(.center).define { [unowned self] flex in
            flex.addItem().width(690~).height(642~).define { [unowned self]  flex in
                flex.addItem(self.theLoginPhoneBgView).width(100%).height(100%).position(.absolute);
                flex.addItem().height(120~).width(100%).alignItems(.center).justifyContent(.center).define { [unowned self] flex in
                    flex.addItem(self.theLoginTipLabel);
                    flex.addItem(self.theCloseButton).position(.absolute).right(0).top(0).width(120~).height(120~)
                }
                flex.addItem().marginHorizontal(30~).height(1~).backgroundColor(UIColor.white);
                
                flex.addItem().cornerRadius(49~).height(98~).width(600~).alignSelf(.center).paddingLeft(30~).direction(.row).alignItems(.center).backgroundColor(UIColor.init(white: 1, alpha: 0.49)).marginTop(60~).define {  [unowned self] flex in
                    flex.addItem(self.theAccountLogoImageView).width(50~).height(50~);
                    flex.addItem(self.theInputAccountView).grow(1).height(98~).marginRight(30~).marginLeft(30~);
                }
                flex.addItem().cornerRadius(49~).height(98~).width(600~).marginTop(50~).alignSelf(.center).paddingLeft(30~).direction(.row).alignItems(.center).backgroundColor(UIColor.init(white: 1, alpha: 0.49)).marginTop(60~).define {  [unowned self] flex in
                    flex.addItem(self.thePassworldLogoImageView).width(50~).height(50~);
                    flex.addItem(self.theInputPasswordView).grow(1).height(98~).marginLeft(30~);
                    flex.addItem(self.theInviteCodeButton).height(98~).width(180~)
                }
                
                flex.addItem(self.theLoginButton).alignSelf(.center).width(600~).height(98~).marginTop(60~);

            }
            
        }
    }
    func configData() {
        
    }
}
