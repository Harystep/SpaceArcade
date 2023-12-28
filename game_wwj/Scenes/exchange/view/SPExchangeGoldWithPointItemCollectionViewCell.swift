//
//  SPExchangeGoldWithPointItemCollectionViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

class SPExchangeGoldWithPointItemCollectionViewCell: UICollectionViewCell, SDCollectionItemType {
    fileprivate let rootFlexContainer: UIView = UIView();
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_exchange_gold_bg"));
        return theView;
    }()
    
    lazy var theGoldLogoImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "space_coin_icon"))
        return theView;
    }()
    
    lazy var theGoldLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30, weight: .medium)~;
        theView.textColor = UIColor.white;
        return theView;
    }()

    lazy var thePointLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 36)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    override init(frame: CGRect) {
        super.init(frame: frame);
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
    func bind(to viewModel: SDCollectionViewModel) {
        if let model = viewModel as? SPExchangeGoldWithPointItemViewModel {
            self.theGoldLabel.text = model.valueGold;
            self.thePointLabel.text = model.valuePoint;
            self.theGoldLabel.flex.markDirty();
            self.thePointLabel.flex.markDirty();
            self.rootFlexContainer.flex.layout();
        }
    }
}
private extension SPExchangeGoldWithPointItemCollectionViewCell {
    func configView() {
        self.contentView.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%)
            flex.addItem().direction(.column).alignItems(.center).marginTop(58~).define { flex in
                flex.addItem(self.theGoldLogoImageView).width(74~).height(74~);
                flex.addItem(self.theGoldLabel);
            }
            flex.addItem(self.thePointLabel).marginTop(50~).alignSelf(.center)
        }
    }
}
