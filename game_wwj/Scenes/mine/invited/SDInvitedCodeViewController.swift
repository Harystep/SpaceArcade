//
//  SDInvitedCodeViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/22.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa

class SDInvitedCodeViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_invited_bg"))
        return theView;
    }()
    
    lazy var theInvitedCodeBgView: UIView = {
        let theView = UIView.init()
        return theView;
    }()
    
    lazy var theInvitedBgView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_shared_bg"))
        return theView;
    }()
    
    
    lazy var theInvitedTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 36)~;
        theView.textColor = UIColor.init(hex: 0x333333);
        theView.text = "每邀请一位好友加入并输入您的邀请码，您和被邀请人都将获得1钻石奖励，每个用户最高可获得5钻石";
        theView.numberOfLines = 0;
        
        return theView;
    }()
    
    
    lazy var theCodeBgView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_input_code_bg"))
        return theView;
    }()
    
    lazy var theCodeTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 40)~;
        theView.textColor = UIColor.init(hex: 0x333333);
        return theView;
    }()
    
    lazy var theInvitedSharedBgView: SPGradientView = {
        let theView = SPGradientView([UIColor.init(hex: 0xFFAE0A)!.cgColor, UIColor.init(hex: 0xFEA90A)!.cgColor], CGPoint.init(x: 0, y: 0), CGPoint.init(x: 1, y: 1));
        theView.backgroundColor = UIColor.init(hex: 0xF4740B);
        return theView;
    }()
    
    lazy var theInvitedSharedTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.toZhenYan(size: 40)~;
        theView.textColor = UIColor.white;
        theView.text = "邀请微信好友";
        return theView;
    }()
    
    lazy var theInputCodeButton: UIButton = {
        let theView = UIButton.init();
        theView.setTitle("填写邀请码", for: .normal);
        theView.titleLabel?.font = UIFont.toZhenYan(size: 32)~
        theView.setTitleColor(UIColor.init(hex: 0x9789C8), for: .normal);
        return theView;
    }()
    let inputInvitedCodeTrigger: PublishSubject<String> = PublishSubject();

    init() {
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        if #available(iOS 15.0, *) {
            let bar = UINavigationBarAppearance.init();

            bar.configureWithTransparentBackground()
            bar.backgroundColor = UIColor.clear;
            bar.backgroundEffect =  nil;
            
            bar.titleTextAttributes = [.foregroundColor: UIColor.white];
            self.navigationController?.navigationBar.scrollEdgeAppearance = bar;
            self.navigationController?.navigationBar.standardAppearance = bar;
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default);
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white];
//            self.navigationController?.navigationBar.sets
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theInvitedCodeBgView.flex.marginBottom(self.view.pin.safeArea.bottom + 12~);
        self.rootFlexContainer.flex.layout()
        self.theInvitedSharedBgView.layer.masksToBounds = true;
        self.theInvitedSharedBgView.layer.cornerRadius = self.theInvitedSharedBgView.frame.size.height / 2.0;
    }
   
    
    
    typealias ViewModel = SDInvitedCodeViewModel;
    var viewModel: Attachable<SDInvitedCodeViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDInvitedCodeViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
       
        return SDInvitedCodeViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            inputInvitedCodeTrigger: self.inputInvitedCodeTrigger.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SDInvitedCodeViewModel) -> SDInvitedCodeViewModel {
        viewModel.currentUser.asObservable().subscribe(onNext: { user in
            self.theCodeTitleLabel.text = user.inviteCode;
        }).disposed(by: disposeBag);
        viewModel.inputCodeResult.asObservable().subscribe().disposed(by: disposeBag);
        return viewModel;
    }
    
}
private extension SDInvitedCodeViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%)
            flex.addItem().width(100%).height(100%).direction(.column).alignItems(.center).justifyContent(.end).define { [unowned self] flex in
                flex.addItem(self.theInvitedCodeBgView).direction(.column).alignItems(.center).width(678~).height(778~).marginBottom(12~).define { [unowned self] flex in
                    flex.addItem(self.theInvitedBgView).width(100%).height(100%).position(.absolute);
                    
                    flex.addItem(self.theInvitedTitleLabel).marginTop(156~).marginLeft(30~).marginRight(30~);
                    flex.addItem().justifyContent(.center).marginTop(60~).alignItems(.center).width(468~).height(108~).define { [unowned self] flex in
                        flex.addItem(self.theCodeBgView).position(.absolute).width(100%).height(100%)
                        flex.addItem(self.theCodeTitleLabel)
                    }
                    
                    flex.addItem().marginTop(70~).justifyContent(.center).alignItems(.center).width(468~).height(108~).define { [unowned self] flex in
                        flex.addItem(self.theInvitedSharedBgView).position(.absolute).width(100%).height(100%)
                        flex.addItem(self.theInvitedSharedTitleLabel);
                    }
                    flex.addItem(self.theInputCodeButton).marginTop(12~).width(486~).height(64~);
                }
            }
        }
        self.theInputCodeButton.addTarget(self, action: #selector(onTapInputCode(_:)), for: .touchUpInside);
        
    }
    func configData() {

    }
    
    @objc func onTapInputCode(_ sender: UIButton) {
        let viewController = SDInputInviteCodeViewController();
        viewController.modalPresentationStyle = .overCurrentContext;
        self.navigationController?.definesPresentationContext = true;
        self.navigationController?.providesPresentationContextTransitionStyle = true;
        self.navigationController?.present(viewController, animated: false)
        viewController.inputInvitedCodeTrigger.asObserver().subscribe(onNext: { [weak self] input in
            guard let self = self else { return }
            self.inputInvitedCodeTrigger.onNext(input)
        }).disposed(by: disposeBag);
    }
}
