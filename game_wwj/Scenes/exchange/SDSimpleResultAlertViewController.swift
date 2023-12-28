//
//  SDSuccessAlertViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/8/16.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize


class SDSimpleResultAlertViewController: UIViewController {

    fileprivate let rootFlexContainer: UIView = UIView();
    
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_simple_failed"));
        return theView;
    }()
    
    lazy var theLogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_faile_x"));
        return theView;
    }()
    
    lazy var theResultLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.init(hex: 0xEEAA29);
        theView.font = UIFont.toZhenYan(size: 36)~;
        theView.text = self.resultTitle;
        return theView;
    }()
    
    lazy var theSureButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage.init(named: "ico_exchnage_sure"), for: .normal);
        return theView;
    }()
    
    let resultTitle: String;

    init(_ title: String) {
        resultTitle = title;
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.rootFlexContainer.flex.paddingTop(self.view.safeAreaInsets.top).paddingBottom(self.view.safeAreaInsets.bottom).layout()
        self.rootFlexContainer.backgroundColor = UIColor.init(white: 0, alpha: 0.88);
    }
    @objc func onDissmissAlert(_ sender: Any) {
        self.dismiss(animated: false);
    }
}
private extension SDSimpleResultAlertViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(630~).height(368~).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().direction(.column).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theLogoImageView).width(88~).height(88~).marginTop(64~);
                    flex.addItem(self.theResultLabel).marginTop(20~);
                    flex.addItem(self.theSureButton).width(332~).height(76~).marginTop(40~);
                }
            }
        }
        
        self.theSureButton.addTarget(self, action: #selector(onDissmissAlert(_:)), for: .touchUpInside);
    }
}

