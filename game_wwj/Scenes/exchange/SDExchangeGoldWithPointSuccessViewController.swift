//
//  SDExchangeGoldWithPointSuccessViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SDExchangeGoldWithPointSuccessViewController: UIViewController {
    fileprivate let rootFlexContainer: UIView = UIView();
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_exchange_bg"))
        return theView;
    }()
    
    lazy var theRightImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_exchange_right"))
        return theView;
    }()
    lazy var theRightTitleLabel: UILabel = {
        let theView = UILabel.init();
        let attribute = NSAttributedString(string: "兑换成功", attributes: [NSAttributedString.Key.font: UIFont.toZhenYan(size: 36)~, NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xEEAA29)!]);
        theView.attributedText = attribute;
        return theView;
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    func resultType(title:NSString) {
        let attribute = NSAttributedString(string: "\(title)", attributes: [NSAttributedString.Key.font: UIFont.toZhenYan(size: 36)~, NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xEEAA29)!])
        self.theRightTitleLabel.attributedText = attribute
        self.theRightImageView.flex.markDirty()
        self.theRightImageView.alpha = 0.0;
        self.rootFlexContainer.flex.define { flex in
            flex.addItem().direction(.column).alignItems(.center).marginTop(-200~).define { [unowned self] flex in
                flex.addItem(self.theRightTitleLabel)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.perform(#selector(onDissmissViewController), with: self, afterDelay: 2);
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.rootFlexContainer.flex.paddingTop(self.view.safeAreaInsets.top).paddingBottom(self.view.safeAreaInsets.bottom).layout()
        
        self.rootFlexContainer.backgroundColor = UIColor.init(white: 0, alpha: 0.88);
    }
    @objc func onDissmissViewController() {
        self.dismiss(animated: false)
    }
}

private extension SDExchangeGoldWithPointSuccessViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer)
        self.rootFlexContainer.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(638~).height(446~).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().direction(.column).alignItems(.center).marginTop(200~).define { [unowned self] flex in
                    flex.addItem(self.theRightImageView).width(88~).height(88~);
                    flex.addItem(self.theRightTitleLabel).marginTop(20~);
                }
            }
        }
    }
}
