//
//  SPGameSettlementRecordTableViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
import SDWebImage

protocol SDDollLogDetailSettelementDelegate: class {
    func onComplaintForSettelement(_ data: SDDollLogDetailSettelementData);
}

class SPGameSettlementRecordTableViewCell: UITableViewCell, SDTableViewCellType {
    weak var settelementDelegate: SDDollLogDetailSettelementDelegate?;

    fileprivate let rootFlexController = UIView();
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_game_log_bg"))
        return theView;
    }()
    
    lazy var theResultImageView: UIImageView = {
        let theView = UIImageView.init();
        theView.contentMode = .scaleAspectFit;
        return theView;
    }()
    lazy var theNameLabel: UILabel = {
        let theView = UILabel.init();
        return theView;
    }()
    lazy var theTimelabel : UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var theAppleButton: UIButton = {
        let theView = UIButton.init();
        theView.setTitle("结算申诉", for: .normal);
        theView.titleLabel?.font = UIFont.systemFont(ofSize: 32)~;
        theView.setBackgroundImage(UIImage(named: "ico_game_log_apply_bg"), for: .normal)
        return theView;
    }()
    private var settelementData: SPGameSettlementRecordViewModel? = nil;

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.configView();
        self.selectionStyle = .none;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: SDTableViewModel) {
        if let model = viewModel as? SPGameSettlementRecordViewModel {
            self.settelementData = model;
            self.theResultImageView.sd_setImage(with: URL.init(string: model.settelementImageUrl));
            self.theNameLabel.attributedText = model.settelementResult;
            self.theTimelabel.text = model.settelementTime;
            self.theNameLabel.flex.markDirty();
            self.theNameLabel.flex.markDirty();
            self.contentView.setNeedsLayout();
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.width(100%).height(100%).left().top();
        self.rootFlexController.flex.layout();
    }
    
    @objc func onComplaintPress(_ sender: UIButton) {
        guard let delegate = self.settelementDelegate else { return }
        guard let settelementData = self.settelementData else { return }
        delegate.onComplaintForSettelement(settelementData.originData);
    }

}

private extension SPGameSettlementRecordTableViewCell {
    func configView() {
        self.contentView.addSubview(self.rootFlexController);
        self.contentView.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.clear;
        self.rootFlexController.flex.alignItems(.center).paddingTop(24~).define { [unowned self] flex in
            flex.addItem().width(690~).height(246~).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().height(90~).marginTop(28~).marginHorizontal(20~).direction(.row).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theResultImageView).width(158~).height(90~);
                    
                    flex.addItem().marginLeft(20~).direction(.column).justifyContent(.spaceBetween).define { [unowned self] flex in
                        flex.addItem(self.theNameLabel);
                        flex.addItem(self.theTimelabel).marginTop(10~);
                    }
                }
                flex.addItem().width(100%).grow(1).justifyContent(.center).alignItems(.center).define { [unowned self] flex in
                    flex.addItem().width(332~).height(66~).define { [unowned self] flex in
                        flex.addItem(self.theAppleButton).width(100%).height(100%);
                    }
                }
                
            }
        }
        self.theAppleButton.addTarget(self, action: #selector(onComplaintPress(_:)), for: .touchUpInside);

    }
}
