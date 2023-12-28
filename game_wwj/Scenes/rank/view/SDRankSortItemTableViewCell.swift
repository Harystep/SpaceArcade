//
//  SDRankSortItemTableViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

class SDRankSortItemTableViewCell: UITableViewCell, SDTableViewCellType {
    
    fileprivate let rootFlexContainer: UIView = UIView();
    //ico_rank_cell_mine
    lazy var theCellBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_rank_cell_other"))
        return theView;
    }()
    
    lazy var theCellSortLabel: UILabel = {
        let theView = UILabel.init();
        theView.textColor = UIColor.white;
        theView.font = UIFont.boldSystemFont(ofSize: 34)~;
        theView.textAlignment = .center;
        return theView;
    }()
    lazy var theCellAvatarView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_default_avatar"))
        return theView;
    }()
    
    lazy var theCellNameLabel: UILabel = {
        let theView = UILabel.init()
        theView.textColor = UIColor.white;
        theView.font = UIFont.systemFont(ofSize: 28)~;
        return theView;
    }()
    lazy var theRankValueLabel : UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.textColor = UIColor.init(hex: 0xEEAA29);
        return theView;
    }()

    lazy var theRankTypeLabel : UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.systemFont(ofSize: 24)~;
        theView.textColor = UIColor.init(hex: 0xEEAA29);
        return theView;
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.width(100%).height(100%).left().top();
        self.rootFlexContainer.flex.layout();
        self.theCellAvatarView.layer.masksToBounds = true;
        self.theCellAvatarView.layer.cornerRadius = self.theCellAvatarView.frame.size.height / 2.0;
    }
    
    func bind(to viewModel: SDTableViewModel) {
        if let model = viewModel as? SDRankSortItemViewModel {
            self.theCellSortLabel.text = model.rankSort;
            self.theCellAvatarView.sd_setImage(with: URL(string: model.avatar), placeholderImage: UIImage(named: "ico_default_avatar"), context: nil);
            self.theCellNameLabel.text = model.nickName;
            self.theRankValueLabel.text = model.rankValue;
            self.theRankTypeLabel.text = model.rankTypeString;
            if model.rankType == .sortKind {
                self.theCellBgImageView.image = UIImage(named: "ico_rank_cell_other")
                self.theRankTypeLabel.textColor = UIColor.init(hex: 0xEEAA29)
                self.theRankValueLabel.textColor = UIColor.init(hex: 0xEEAA29)
            } else {
                self.theCellBgImageView.image = UIImage(named: "ico_rank_cell_mine")
                self.theRankTypeLabel.textColor = UIColor.white
                self.theRankValueLabel.textColor = UIColor.white
            }
            self.theCellSortLabel.flex.markDirty();
            self.theCellNameLabel.flex.markDirty();
            self.theRankValueLabel.flex.markDirty()
            self.theRankTypeLabel.flex.markDirty()
            self.rootFlexContainer.flex.layout();
        }
    }

}

private extension SDRankSortItemTableViewCell {
    func configView() {
        self.contentView.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.clear;
        self.contentView.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem().width(694~).height(108~).alignSelf(.center).direction(.row).alignItems(.center).justifyContent(.spaceBetween).define { [unowned self] flex in
                flex.addItem(self.theCellBgImageView).width(100%).height(100%).position(.absolute);
                flex.addItem().direction(.row).alignItems(.center).define {  [unowned self] flex in
                    flex.addItem(self.theCellSortLabel).width(88~);
                    flex.addItem(self.theCellAvatarView).width(70~).height(70~);
                    flex.addItem(self.theCellNameLabel).marginLeft(16~);
                }
                flex.addItem().direction(.row).marginRight(30~).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theRankValueLabel).maxWidth(320~);
                    flex.addItem(self.theRankTypeLabel).marginLeft(30~);
                }
            }
        }
    }
}
