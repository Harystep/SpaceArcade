//
//  SPLineTabItemView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
class SPLineTabItemView: UIControl {

    private let rootFlexContainer: UIView = UIView();
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 32)~;
        theView.textColor = UIColor.white;
        theView.text = self.tab;
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    lazy var theLineView: UIView = {
        let theView = UIView.init();
        theView.isUserInteractionEnabled = false;
        theView.backgroundColor = UIColor.init(hex: 0xEEAA29)
        return theView;
    }()

    let tab: String;
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.theTitleLabel.textColor = UIColor.init(hex: 0xEEAA29)
                self.theLineView.isHidden = false;
            } else {
                self.theTitleLabel.textColor = UIColor.white;
                self.theLineView.isHidden = true;
            }
        }
    }
    init(_ title: String) {
        self.tab = title;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
    }

}
private extension SPLineTabItemView{
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.isUserInteractionEnabled = false;
        self.rootFlexContainer.flex.alignItems(.center).justifyContent(.center).define { [unowned self] flex in
            flex.addItem(self.theTitleLabel);
            flex.addItem(self.theLineView).width(24~).height(6~);
        }
        self.theLineView.layer.masksToBounds = true;
        self.theLineView.layer.cornerRadius = 3~;
        self.theLineView.isHidden = true;
    }
}
