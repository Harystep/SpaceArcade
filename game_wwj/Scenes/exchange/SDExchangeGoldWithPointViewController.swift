//
//  SDExchangeGoldWithPointViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize


typealias ExchangeGoldFinish = () -> Void;

class SDExchangeGoldWithPointViewController: UIViewController {
    fileprivate let rootFlexContainer: UIView = UIView();
    
    var sureExchangeFinish: ExchangeGoldFinish?
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_exchange_bg"))
        return theView;
    }()
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.attributedText = self.exchnageTitle;
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
    
    let exchnageTitle: NSAttributedString;
    init(_ title: NSAttributedString) {
        self.exchnageTitle = title;
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.rootFlexContainer.flex.paddingTop(self.view.safeAreaInsets.top).paddingBottom(self.view.safeAreaInsets.bottom).layout()
        
        self.rootFlexContainer.backgroundColor = UIColor.init(white: 0, alpha: 0.88);
    }
    
    @objc func onSureAlertPress(_ sender: UIButton) {
        self.dismiss(animated: false);
        self.sureExchangeFinish?()
    }
    @objc func onCancelAlertPress(_ sender: UIButton) {
        self.dismiss(animated: false);
    }
}

private extension SDExchangeGoldWithPointViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer)
        self.rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(638~).height(446~).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().direction(.column).alignItems(.center).marginTop(200~).define { [unowned self] flex in
                    flex.addItem(self.theTitleLabel);
                    flex.addItem().direction(.row).alignItems(.center).marginTop(74~).define { [unowned self] flex in
                        flex.addItem(self.theCancelButton).width(222~).height(76~);
                        flex.addItem(self.theSureButton).width(222~).height(76~).marginLeft(52~);
                    }
                }
            }
        }
        self.theCancelButton.addTarget(self, action: #selector(onCancelAlertPress(_:)), for: .touchUpInside);
        self.theSureButton.addTarget(self, action: #selector(onSureAlertPress(_:)), for: .touchUpInside);
    }
}
