//
//  SDRankUserInfoView.swift
//  game_wwj
//
//  Created by oneStep on 2023/7/6.
//

import Foundation
import FlexLayout
import PinLayout
import SwiftyFitsize

class SDRankUserInfoView: UIView {
    
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
        
    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    func rankData(viewModel:SDSummaryRankData, type: Int){
        self.theCellSortLabel.text = (viewModel.rank == 0 ? "--":"\(viewModel.rank)")
        self.theCellAvatarView.sd_setImage(with: URL(string: viewModel.avatar), placeholderImage: UIImage(named: "ico_default_avatar"), context: nil)
        self.theCellNameLabel.text = viewModel.nickName
        self.theRankValueLabel.text = "\(viewModel.total)"
        if type == 0 {//SDSummaryRankData SDSummaryRankData
            self.theCellBgImageView.image = UIImage(named: "ico_rank_cell_mine")
            self.theRankTypeLabel.textColor = UIColor.init(hex: 0xEEAA29)
            self.theRankValueLabel.textColor = UIColor.init(hex: 0xEEAA29)
            self.theRankTypeLabel.text = "王者能量"
        } else {
            self.theCellBgImageView.image = UIImage(named: "ico_rank_cell_other")
            self.theRankTypeLabel.textColor = UIColor.white
            self.theRankValueLabel.textColor = UIColor.white
            self.theRankTypeLabel.text = "大亨值"
        }
        self.theCellSortLabel.flex.markDirty();
        self.theCellNameLabel.flex.markDirty();
        self.theRankValueLabel.flex.markDirty()
        self.theRankTypeLabel.flex.markDirty()
        self.rootFlexContainer.flex.layout();
    }
}

private extension SDRankUserInfoView {
    func configView() {
        self.backgroundColor = UIColor.clear;
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem().width(694~).height(108~).alignSelf(.center).direction(.row).alignItems(.center).justifyContent(.spaceBetween).define { [unowned self] flex in
                flex.addItem(self.theCellBgImageView).width(100%).height(100%).position(.absolute);
                flex.addItem().direction(.row).alignItems(.center).define {  [unowned self] flex in
                    flex.addItem(self.theCellSortLabel).width(88~);
                    flex.addItem(self.theCellAvatarView).width(70~).height(70~);
                    flex.addItem(self.theCellNameLabel).marginLeft(16~);
                }
                flex.addItem().direction(.row).marginRight(30~).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theRankValueLabel);
                    flex.addItem(self.theRankTypeLabel).marginLeft(30~);
                }
            }
        }
    }
}
