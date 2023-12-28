//
//  SDInputNameViewController.swift
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
import SPIndicator

class SDInputNameViewController: SDAlertPortraitViewController {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theInputInvitedCodeBg: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_input_name_bg"))
        return theView;
    }()
    
    lazy var theInputCodeBgView: UIImageView = {
        let theView = UIImageView.init(image: UIImage(named: "ico_input_bg"));
        return theView;
    }()

    lazy var theInputCodeView: UITextField = {
        let theView = UITextField.init();
        theView.placeholder = "请输入6位以内的用户昵称";
        theView.font = UIFont.toZhenYan(size: 36)~
        theView.text = self.defaultName;
        return theView;
    }()
    
    lazy var theCancelButton: UIButton = {
        let theView = UIButton.init()
        theView.setBackgroundImage(UIImage(named: "ico_exchange_cancel"), for: .normal);
        return theView;
    }()
    
    lazy var theSureButton: UIButton = {
        let theView = UIButton.init();
        theView.setBackgroundImage(UIImage(named: "ico_exchnage_sure"), for: .normal);
        return theView;
    }()
    
    let inputNameTrigger: PublishSubject<String> = PublishSubject();
    
    let defaultName: String
    
    init(_ name: String) {
        self.defaultName = name;
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
}

private extension SDInputNameViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(640~).height(470~).alignItems(.center).define { [unowned self] flex in
                flex.addItem(self.theInputInvitedCodeBg).position(.absolute).width(100%).height(100%);
                flex.addItem().width(522~).height(98~).marginTop(182~).define { [unowned self]  flex in
                    flex.addItem(self.self.theInputCodeBgView).position(.absolute).width(100%).height(100%);
                    flex.addItem(self.theInputCodeView).width(100%).height(100%).marginHorizontal(30~);
                }
                flex.addItem().direction(.row).marginTop(54~).define { [unowned self] flex in
                    flex.addItem(self.theCancelButton).width(222~).height(76~);
                    flex.addItem(self.theSureButton).width(222~).height(76~).marginLeft(48~);
                }
            }
        }
        self.theCancelButton.addTarget(self, action: #selector(onCancelTap(_:)), for: .touchUpInside);
        self.theSureButton.addTarget(self, action: #selector(onSureTap(_:)), for: .touchUpInside);
    }
    func configData() {
        
    }
    
    @objc func onCancelTap(_ sender: UIButton) {
        self.dismiss(animated: false);
    }
    
    @objc func onSureTap(_ sender: UIButton) {
        guard let inputText = self.theInputCodeView.text else {
            SPIndicator.present(title: "请输入用户名称", haptic: .error);
            return;
        }
        if inputText.isEmpty {
            SPIndicator.present(title: "请输入用户名称", haptic: .error);
            return;
        }
        if inputText.count > 6 {
            SPIndicator.present(title: "请输入6位以内的用户昵称", haptic: .error);
            return;
        }
        self.inputNameTrigger.onNext(inputText);
        self.dismiss(animated: false);
    }
}
