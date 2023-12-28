//
//  SDRedCloseView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

class SDRedCloseView: UIControl {
    fileprivate let rootFlexController = UIView()

    lazy var theBgView1: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor(hex: 0xF45450);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 27~;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theBgView2: UIView = {
        let theView = UIView.init();
        theView.backgroundColor = UIColor(hex: 0xF78F73);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 22~;
        theView.isUserInteractionEnabled = false;

        return theView;
    }()
    
    lazy var theCloseImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_white_close"));
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    init() {
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%)
        self.rootFlexController.flex.layout();
    }
    
}

private extension SDRedCloseView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.isUserInteractionEnabled = false;
        self.rootFlexController.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            let bgView1 = UIView.init();
            bgView1.isUserInteractionEnabled = false;
            flex.addItem(bgView1).position(.absolute).width(100%).height(100%).justifyContent(.center).alignItems(.center).define {[unowned self] flex in
                flex.addItem(self.theBgView1).width(54~).height(54~)
            }
            let bgView2 = UIView.init();
            bgView2.isUserInteractionEnabled = false;
            flex.addItem(bgView2).position(.absolute).width(100%).height(100%).justifyContent(.center).alignItems(.center).define {[unowned self] flex in
                flex.addItem(self.theBgView2).width(44~).height(44~)
            }
            
            let bgView3 = UIView.init();
            bgView3.isUserInteractionEnabled = false;
            flex.addItem(bgView3).position(.absolute).width(100%).height(100%).justifyContent(.center).alignItems(.center).define {[unowned self] flex in
                flex.addItem(self.theCloseImageView).width(24~).height(24~);
            }
            
        }
    }
}
