//
//  SDNormalNavgationBarView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/8.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SDNormalNavgationBarView: UIView {

    private let rootFlexContainer: UIView = UIView();
    
    lazy var theNavigationBarView: UIView = {
        let theView = UIView.init();
        theView.layer.masksToBounds = true;
        return theView;
    }()
    lazy var theTopBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_top_bg_img"))
        return theView;
    }()
    
    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.theTopBgImageView.flex.top(-1048~ + self.pin.safeArea.top - 44);
        self.theNavigationBarView.flex.height(self.pin.safeArea.top);
        self.rootFlexContainer.flex.layout();
    }
    

}

private extension SDNormalNavgationBarView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theNavigationBarView).position(.absolute).top(0).width(100%).height(44).define { [unowned self] flex in
                flex.addItem(self.theTopBgImageView).position(.absolute).width(1130~).height(1308~).left(-350~).top(-1048~);
            }
        }
    }
}
