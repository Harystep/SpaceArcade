//
//  SDLoginViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/2.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import AuthenticationServices
import SPIndicator

import ATAuthSDK

class SDLoginViewController: SDPortraitViewController, ViewModelAttaching {
    
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theCloseButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage(named: "ico_white_close"), for: .normal);
//        theView.addTarget(self, action: #selector(closeOp), for: .touchUpInside)
        return theView;
    }()
    
//    @objc func closeOp() {
//        self.dismiss(animated: true)
//    }
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_login_bg"));
        return theView;
    }()
    
    lazy var theLogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_logo"))
        theView.contentMode = .scaleAspectFit;
        theView.isHidden = true
        return theView;
    }()
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.toZhenYan(size: 52~);
        theView.textColor = UIColor.init(hex: 0xDFDFFF);
        theView.text = "欢迎登陆太空街机";
        return theView;
    }()
    
    lazy var theAgreementTipLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        theView.text = "登录注册即代表您同意";
        return theView;
    }()
    
    lazy var theAgreementTipButton: UIButton = {
        let theView = UIButton.init()
        theView.setTitle("《用户协议》", for: .normal);
        theView.setTitleColor(UIColor.white, for: .normal);
        theView.titleLabel?.font = UIFont.systemFont(ofSize: 28)~;
        return theView;
    }()
    lazy var theAndLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        theView.text = "和";
        return theView;
    }()
    
    lazy var thePriceAgreementTipButton : UIButton = {
        let theView = UIButton.init()
        theView.setTitle("《隐私协议》", for: .normal);
        theView.setTitleColor(UIColor.white, for: .normal);
        theView.titleLabel?.font = UIFont.systemFont(ofSize: 28)~;
        return theView;
    }()
    
    lazy var theAppleLoginButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage(named: "ico_apple"), for: .normal);
        return theView;
    }()
    
    lazy var thePhoneLoginButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage(named: "ico_phone"), for: .normal);
//        theView.isHidden = true
        return theView;
    }()
    
    lazy var theFastPhoneLoginButton: SDBgImageButton = {
        let theView = SDBgImageButton("一键手机号登录");
        return theView;
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theCloseButton.flex.top(self.view.pin.safeArea.top);
        self.rootFlexContainer.flex.layout()
        
    }
    private let appleLoginTrigger :PublishSubject<String> = PublishSubject<String>();
    private let fastLoginTokenTrigger: PublishSubject<String> = PublishSubject<String>();
    typealias ViewModel = SDLoginViewModel;
    var viewModel: Attachable<SDLoginViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDLoginViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SDLoginViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            didLoginByPhone: thePhoneLoginButton.rx.tap.asDriverOnErrorJustComplete(),
            appleLoginTrigger: appleLoginTrigger.asDriverOnErrorJustComplete(),
            toCloseTrigger: self.theCloseButton.rx.tap.asDriver(),
            fastLoginTokenTrigger: self.fastLoginTokenTrigger.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SDLoginViewModel) -> SDLoginViewModel {
        viewModel.fetching
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        return viewModel;
    }
}
private extension SDLoginViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem().width(100%).height(100%).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).width(100%).height(100%)
                flex.addItem().width(100%).grow(1).position(.absolute).alignItems(.center).define { flex in
                    flex.addItem(self.theLogoImageView).width(280~).height(210~).marginTop(296~);
                    flex.addItem(self.theTitleLabel).marginTop(36~);
                }
            }
            flex.addItem().position(.absolute).direction(.column).alignItems(.center).width(100%).bottom(0).left(0).paddingBottom(self.view.pin.safeArea.bottom).define { [unowned self]  flex in
                
                flex.addItem(self.theFastPhoneLoginButton).width(644~).height(112~).marginBottom(106~);
                
                flex.addItem().direction(.row).alignItems(.center).marginBottom(40~).define {[unowned self]  flex in
                    flex.addItem(self.theAppleLoginButton).width(80~).height(80~);
                    flex.addItem(self.thePhoneLoginButton).width(80~).height(80~).marginLeft(100~);
                }
                flex.addItem().direction(.row).alignItems(.center).marginBottom(140~).define { [unowned self]  flex in
                    flex.addItem(self.theAgreementTipLabel);
                    flex.addItem(self.theAgreementTipButton);
                    flex.addItem(self.theAndLabel)
                    flex.addItem(self.thePriceAgreementTipButton)
                }
            }
            flex.addItem(self.theCloseButton).width(88~).height(88~).position(.absolute).top(0).left(0);
        }
    }
    func configData() {
        self.theAppleLoginButton.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside);
        
        self.theAgreementTipButton.addTarget(self, action: #selector(onTapUserAgreement(_:)), for: .touchUpInside);
        self.thePriceAgreementTipButton.addTarget(self, action: #selector(onTapPriceAgreement(_:)), for: .touchUpInside);
        self.theFastPhoneLoginButton.addTarget(self, action: #selector(onFastLogin(_:)), for: .touchUpInside);
        
        self.checkAndPrepareEnv();
    }
    
    @objc func signInWithApple() {
        if #available(iOS 13.0, *) {
            let appleIdProvider = ASAuthorizationAppleIDProvider.init();
            let appleIdRequest = appleIdProvider.createRequest();
            appleIdRequest.requestedScopes = [.fullName, .email];
            let autorizationController = ASAuthorizationController.init(authorizationRequests: [appleIdRequest]);
            autorizationController.delegate = self;
            autorizationController.presentationContextProvider = self;
            autorizationController.performRequests();
        } else {
            SPIndicator.present(title: "该系统版本不可用Apple登录", haptic: .error);
        }
    }
    
    @objc func onTapUserAgreement(_ sender: UIButton) {
        self.pushIntoAgreement(AppDefine.userAgreementHTMLURL);

    }
    @objc func onTapPriceAgreement(_ sender: UIButton) {
        self.pushIntoAgreement(AppDefine.gameAgreementHTMLURL);
    }
    
    @objc func onFastLogin(_ sender: UIButton) {
        let model = self.getFastLoginAlertModel();
        TXCommonHandler.sharedInstance().getLoginToken(withTimeout: 3, controller: self, model: model, complete: {
            [weak self] result in
            guard let self = self else {return}
            log.debug("[fastLogin] ---> \(result)");
//            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];

            if let resultCode = result["resultCode"] as? String {
                if resultCode.elementsEqual(PNSCodeLoginControllerClickProtocol) {
                    if let url = result["url"] as? NSString {
                        DispatchQueue.main.async {
                            let webViewController = SDWebViewController(url as String);
//                            self.present(webViewController, animated: true);
//                            TXCommonHandler.sharedInstance().
                            self.navigationController?.pushViewController(webViewController, animated: true);
                        }
                    }
                }else if resultCode.elementsEqual(PNSCodeSuccess) {
                    if let token = result["token"] as? String {
//                        [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
                        self.fastLoginTokenTrigger.onNext(token);
                        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true);
                    }
                } else if resultCode.elementsEqual(PNSCodeLoginControllerClickLoginBtn) {
                    if let isChecked = result["isChecked"] as? Int {
                        if isChecked == 0 {
                            SPIndicator.present(title: "警告", message: "请先点击同意协议", haptic: .error);
                        }
                    }
                }
            }
        })
    }
    
    func checkAndPrepareEnv() {
        TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: 3, complete: {
            result in
            log.debug("[accelerateLoginPage] ---> \(result)")
        })
        
//        TXCommonHandler.sharedInstance().accelerateVerify(withTimeout: 3, complete: {
//            result in
//            log.debug("[accelerateVerify] ---> \(result)")
//        })
        
        TXCommonHandler.sharedInstance().checkEnvAvailable(complete: { result in
            log.debug("[checkEnvAvailable] ---> \(result)")
        })
    }
    
    func pushIntoAgreement(_ url: String) {
        let viewController = SDWebViewController(url);
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    func getFastLoginAlertModel() -> TXCustomModel {
        let model: TXCustomModel = TXCustomModel();
//        model.suspendDisMissVC = true;
        
        model.supportedInterfaceOrientations = .portrait;
        model.alertCornerRadiusArray = [10, 10, 10, 10];
        model.alertTitleBarColor = UIColor.clear;
        model.alertTitle = NSAttributedString(string: "");
        model.contentViewFrameBlock = { (screenSize, superViewSize, frame) -> CGRect in
            var alertFrame = CGRect.init(x: 0, y: 0, width: 690, height: 648)~;
            alertFrame.origin.x = (superViewSize.width - alertFrame.width) / 2.0;
            alertFrame.origin.y = (superViewSize.height - alertFrame.height) / 2.0;
            return alertFrame;
        }
        model.backgroundImage = UIImage(named: "ico_fast_login_bg")!;
        model.numberFont = UIFont.toZhenYan(size: 64)~;
        model.numberColor = UIColor.white;
        model.numberFrameBlock = { (screenSize, superViewSize, frame) -> CGRect in
            var alertFrame = frame;
            alertFrame.origin.y = 40~;
            return alertFrame;
        }
        
        let closeButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 44, height: 44)));
        closeButton.setImage(UIImage(named: "ico_white_close"), for: .normal);
        model.navMoreView = closeButton;
        model.navMoreViewFrameBlock = { (screenSize, superViewSize, frame) -> CGRect in
            let alertFrame = CGRect.init(x: superViewSize.width - 44, y: 0, width: 44, height: 44);
            return alertFrame;
        }
        model.sloganFrameBlock = { (screenSize, superViewSize, frame) -> CGRect in
            var alertFrame = frame;
            alertFrame.origin.y = 144~;
            return alertFrame;
        }
        
        model.checkBoxImages = [UIImage(named: "ico_not_check")!, UIImage(named: "ico_checked")!];
        model.privacyPreText = "使用手机号码登录并同意";
        model.privacyOne = ["《用户协议》", AppDefine.userAgreementHTMLURL]
        model.privacyTwo = ["《隐私协议》", AppDefine.gameAgreementHTMLURL];
        model.privacyVCIsCustomized = true;
        
        model.privacyFrameBlock = { (screenSize, superViewSize, frame) -> CGRect in
            var alertFrame = frame;
            alertFrame.origin.y = 284~;
            return alertFrame;
        }
        model.loginBtnBgImgs = [UIImage(named: "ico_btn_bg")!, UIImage(named: "ico_btn_bg")!, UIImage(named: "ico_btn_bg")!]
        model.loginBtnFrameBlock = { (screenSize, superViewSize, frame) -> CGRect in
            var alertFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 600, height: 98)~);
            alertFrame.origin.y = 412~;
            alertFrame.origin.x = (superViewSize.width - alertFrame.width) / 2.0;
            return alertFrame;
        }
        model.loginBtnText = NSAttributedString(string: "本机号码一键登录", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 36, weight: .medium)~, NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0x4936B8)!])
        
        return model;
    }
}

extension SDLoginViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let e = error as? ASAuthorizationError {
            var errMessage = "";
            switch e.code {
            case .unknown: errMessage = "授权请求失败未知原因";
            case .canceled: errMessage = "用户取消了授权请求";
            case .invalidResponse: errMessage = "授权请求响应无效";
            case .notHandled: errMessage = "未能处理授权请求";
            case .failed: errMessage = "授权请求失败";
            default: errMessage = "授权请求失败其他原因";
            }
            SPIndicator.present(title: errMessage, haptic: .error);
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let identityToken = appleIdCredential.identityToken {
                if let identityTokenStr = String.init(data: identityToken, encoding: .utf8) {
                    self.appleLoginTrigger.onNext(identityTokenStr);
                }
            }
            
        }
    }
}

extension SDLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.keyWindow?.rootViewController?.view.window)!;
    }
}
