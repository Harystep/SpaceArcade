//
//  SDAuthenticationViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/6.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa


class SDAuthenticationViewController: SDAlertPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theAlertBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_auth_bg"))
        return theView
    }()
    
    lazy var theTipLabel : UILabel = {
        let theView = UILabel.init();
        theView.text = "根据国家相关规定，严禁未成年人进入，请填写您的身份证信息进行认证，未实名认证的用户不能体验任何内容，请尽快完成实名认证";
        theView.numberOfLines = 0;
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 28)~;
        return theView;
    }()
    
    lazy var theInputNameBgView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_input_bg"))
        return theView;
    }()
    
    lazy var theInputNameView: UITextField = {
        let theView = UITextField.init();
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x7D31D1, alpha: 0.31)!, NSAttributedString.Key.font: UIFont.toZhenYan(size: 36)~];
        theView.font = UIFont.toZhenYan(size: 36)~
        theView.attributedPlaceholder = NSAttributedString(string: "请填写真实姓名", attributes: placeholderAttributes);
        return theView;
    }()
    
    lazy var theInputIdBgView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_input_bg"))
        return theView;
    }()
    
    lazy var theInputIdView: UITextField = {
        let theView = UITextField.init();
        let placeholderAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x7D31D1, alpha: 0.31)!, NSAttributedString.Key.font: UIFont.toZhenYan(size: 36)~];
        theView.font = UIFont.toZhenYan(size: 36)~
        theView.attributedPlaceholder = NSAttributedString(string: "请填写真实有效的身份证号", attributes: placeholderAttributes);
        return theView;
    }()
    
    lazy var theSureButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage(named: "ico_sure_bt"), for: .normal);
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
    
    typealias ViewModel = SDAuthenticationViewModel;
    var viewModel: Attachable<SDAuthenticationViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDAuthenticationViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SDAuthenticationViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            didSureTap: self.theSureButton.rx.tap.asDriver(),
            inputYourName: self.theInputNameView.rx.text.orEmpty.asDriver(),
            inputYourID: self.theInputIdView.rx.text.orEmpty.asDriver()
        )
    }();
    func bind(viewModel: SDAuthenticationViewModel) -> SDAuthenticationViewModel {
        
        return viewModel;
    }
}
private extension SDAuthenticationViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.addDismissHandler(self.rootFlexContainer);
        self.rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(638~).height(812~).define { [unowned self] flex in
                flex.addItem(self.theAlertBgImageView).position(.absolute).width(100%).height(100%)
                flex.addItem(self.theTipLabel).marginHorizontal(58~).marginTop(166~);
                flex.addItem().marginTop(36~).alignSelf(.center).define {  [unowned self]  flex in
                    flex.addItem().width(522~).height(98~).alignSelf(.center).define { [unowned self]  flex in
                        flex.addItem(self.theInputNameBgView).width(100%).height(100%).position(.absolute);
                        flex.addItem(self.theInputNameView).marginHorizontal(30~).height(100%).grow(1);
                    }
                    flex.addItem().width(522~).height(98~).marginTop(30~).define { [unowned self]  flex in
                        flex.addItem(self.theInputIdBgView).width(100%).height(100%).position(.absolute);
                        flex.addItem(self.theInputIdView).marginHorizontal(30~).height(100%).grow(1);
                    }
                }
                flex.addItem().grow(1).width(100%).justifyContent(.center).alignItems(.center).define { [unowned self]  flex in
                    flex.addItem(self.theSureButton).width(332~).height(76~);
                }
            }
        }
    }
    func configData() {
        
    }
}
