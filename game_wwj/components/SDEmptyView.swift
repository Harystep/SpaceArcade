//
//  SDEmptyView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/28.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

class SDEmptyView: UIView {
    fileprivate let rootFlexController = UIView()

    lazy var theEmptyImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_no_data"))
        return theView;
    }()
    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.configView();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%);
        self.rootFlexController.flex.layout();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SDEmptyView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theEmptyImageView).width(200~).height(200~);
        }
    }
}
