//
//  SPRecordItemTableViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
import SDWebImage

class SPRecordItemTableViewCell: UITableViewCell, SDTableViewCellType {
  
    
    fileprivate let rootFlexController = UIView();
    
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_record_cell_bg"))
        return theView;
    }()
    
    lazy var theNameLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30, weight: .medium)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    lazy var theTimeLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 28, weight: .medium)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    lazy var theValueLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 32, weight: .medium)~;

        theView.textColor = UIColor.init(hex: 0xEEAA29)
        return theView;
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.width(100%).height(100%).left().top();
        self.rootFlexController.flex.layout();
    }
    func bind(to viewModel: SDTableViewModel) {
        if let model = viewModel as? SPRecordItemViewModel {
            self.theNameLabel.text = model.name;
            self.theTimeLabel.text = model.time;
            self.theValueLabel.text = model.value;
            self.theNameLabel.flex.markDirty();
            self.theTimeLabel.flex.markDirty();
            self.theValueLabel.flex.markDirty();
        }
    }
}

private extension SPRecordItemTableViewCell {
    func configView() {
        self.contentView.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.clear;
        self.contentView.addSubview(self.rootFlexController);
        self.rootFlexController.flex.paddingBottom(24~).define { [unowned self] flex in
            flex.addItem().width(690~).height(146~).direction(.row).alignSelf(.center).alignItems(.center).justifyContent(.spaceBetween).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().direction(.column).marginLeft(20~).define { [unowned self] flex in
                    flex.addItem(self.theNameLabel);
                    flex.addItem(self.theTimeLabel).marginTop(10~);
                }
                flex.addItem(self.theValueLabel).marginRight(20~);
            }
        }
    }
}
