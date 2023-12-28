//
//  SDSignViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

import RxSwift
class SDSignViewController: UIViewController {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theCloseButton : UIButton = {
        let theView = UIButton();
        theView.setImage(UIImage(named: "ico_white_close"), for: .normal);
        return theView;
    }()
    lazy var theLogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_sign_logo_bg"))
        return theView;
    }()
    
    lazy var theSignBgView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_sign_bg"))
        return theView
    }()
    
    lazy var theSignTitleLabel: UILabel = {
        let theView = UILabel.init()
        theView.textColor = UIColor.white;
        theView.font = UIFont.toZhenYan(size: 40)~
        theView.text = "每周签到有礼";
        return theView;
    }()
    var signItemViewList : [SDSignUnitView] = [];
    let signAction: PublishSubject<Void> = PublishSubject();
    let list: [SDSignData];
    let status: Int;
    init(_ list: [SDSignData], status: Int) {
        self.list = list;
        self.status = status;
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
        self.rootFlexContainer.flex.layout()
        self.rootFlexContainer.backgroundColor = UIColor.init(white: 0, alpha: 0.88);
    }
    
}

private extension SDSignViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(100%).height(100%).define { [unowned self] flex in
                flex.addItem(self.theLogoImageView).width(100%).height(100%)
                flex.addItem(self.theCloseButton).width(50).height(50).position(.absolute).top(89).right(0);
            }
            var topHeight:CGFloat = self.k_Height_statusBar()
            if topHeight > 20 {
                topHeight = -1300
            } else {
                topHeight = -1100
            }
            flex.addItem().width(349).height(484).marginTop(topHeight~).define { [unowned self] flex in
                flex.addItem(self.theSignBgView).width(100%).height(100%).position(.absolute)
                flex.addItem(self.theSignTitleLabel).alignSelf(.center).marginTop(29)

                flex.addItem().marginTop(40).direction(.row).width(304).alignSelf(.center).wrap(.wrap).justifyContent(.spaceBetween).define { [unowned self] flex in
                    for i in 0..<self.list.count {
                        let data = self.list[i];
                        if i == 6 {
                            flex.addItem(self.createDaySign(i, data)).width(304).height(103);
                        } else {
                            flex.addItem(self.createDaySign(i, data)).width(96).height(121).marginBottom(15);
                        }
                    }
                }
            }
        }
    }
    
    func k_Height_statusBar() -> CGFloat {
        var statusBarHeight: CGFloat = 0;
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first;
            guard let windowScene = scene as? UIWindowScene else {return 0};
            guard let statusBarManager = windowScene.statusBarManager else {return 0};
            statusBarHeight = statusBarManager.statusBarFrame.height;
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height;
        }
        return statusBarHeight;
    }
    
    func configData() {
        
        self.theCloseButton.addTarget(self, action: #selector(onTapClose(_:)), for: .touchUpInside);
        
    }
    
    func createDaySign(_ index: Int, _ day: SDSignData) -> SDSignUnitView {
        let theView = SDSignUnitView(index, day);
        theView.tag = index;
        theView.addTarget(self, action: #selector(onSignDay(_:)), for: .touchUpInside);
        self.signItemViewList.append(theView);
        return theView;
    }
    
    @objc func onSignDay(_ sender: UIControl) {
        self.signAction.onNext(());
        let filterList = self.signItemViewList.filter { view in
            return view.signData.status == 1;
        }
        if self.status == 1 {
            if let first = filterList.first {
                first.sendSign();
                NotificationCenter.default.post(name: NSNotification.Name("kSendSignOperateKey"), object: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                guard let self = self else {return}
                self.dismiss(animated: false);
            }
        }
    }
    
    @objc func onTapClose(_ sender: UIButton) {
        self.dismiss(animated: false);
    }
}
