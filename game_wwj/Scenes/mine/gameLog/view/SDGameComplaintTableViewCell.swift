//
//  SDGameComplaintTableViewCell.swift
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
class SDGameComplaintTableViewCell: UITableViewCell, SDTableViewCellType {
    
    fileprivate let rootFlexController = UIView();

    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_game_log_bg"))
        return theView;
    }()
    
    lazy var theImageView: UIImageView = {
        let theView = UIImageView.init();
        theView.contentMode = .scaleToFill;
        return theView;
    }()
    lazy var theCellTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30, weight: .medium)~
        theView.textColor = UIColor.white;
        return theView;
    }()
    lazy var theCellTimeLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    lazy var theCellStatusLabel : UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var theAppealStatusLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        theView.textAlignment = .right
        return theView;
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.configView();
        self.selectionStyle = .none;
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.width(100%).height(100%).left().top();
        self.rootFlexController.flex.layout();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: SDTableViewModel) {
        if let model = viewModel as? SDGameComplaintViewModel {
            self.theImageView.sd_setImage(with: URL(string: model.imgUrl)!);
            self.theCellTitleLabel.text = model.appealTitle;
            self.theCellTimeLabel.text = model.appealTime;
            self.theAppealStatusLabel.text = model.appealStatusStr;
            if model.appealStatus == 0 {
                self.theAppealStatusLabel.textColor = UIColor(hex: 0xF95556);
            } else if model.appealStatus == 1 {
                self.theAppealStatusLabel.textColor = UIColor(hex: 0x68E98A);
            } else if model.appealStatus == 2  {
                self.theAppealStatusLabel.textColor = UIColor(hex: 0xE96868);
            }
        }
    }
}

private extension SDGameComplaintTableViewCell{
    func configView() {
        self.contentView.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.clear;
        
        self.contentView.addSubview(self.rootFlexController);
        
        self.rootFlexController.flex.paddingTop(24~).alignItems(.center).define { [unowned self] flex in
            flex.addItem().width(690~).height(196~).direction(.row).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().direction(.row).marginLeft(20~).marginRight(20~).marginTop(22~).height(142~).grow(1).alignItems(.center).define { [unowned self]  flex in
                    flex.addItem(self.theImageView).width(160~).height(142~);
                    flex.addItem().marginLeft(20~).direction(.column).justifyContent(.spaceBetween).grow(1).define { [unowned self] flex in
                        flex.addItem(self.theCellTitleLabel).grow(1);
                        flex.addItem(self.theCellTimeLabel).marginTop(10~)
//                        flex.addItem(self.theCellStatusLabel).marginTop(10~)
                    }
                    flex.addItem(self.theAppealStatusLabel).width(100~);
                }
            }
        }
    }
}
