//
//  SDRankSortView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

class SDRankSortView: UIView {
    
    fileprivate let rootFlexContainer: UIView = UIView();
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_rank_sort_bg"))
        return theView;
    }()
    
    lazy var theSort2ImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_rank_sort_2"))
        return theView
    }()
    lazy var theSort1ImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_rank_sort_1"))
        return theView
    }()
    lazy var theSort3ImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_rank_sort_3"))
        return theView
    }()
    
    lazy var theSort2UserInfoView: SDRankSortUserInfoView = {
        let theView = SDRankSortUserInfoView(self.rankType);
        return theView;
    }()
    lazy var theSort1UserInfoView: SDRankSortUserInfoView = {
        let theView = SDRankSortUserInfoView(self.rankType);
        return theView;
    }()
    
    lazy var theSort3UserInfoView: SDRankSortUserInfoView = {
        let theView = SDRankSortUserInfoView(self.rankType);
        return theView;
    }()
    
    var rankList: [SDRankSortItemViewModel] = [] {
        didSet {
            if rankList.count > 0 {
                self.theSort1UserInfoView.rankData = rankList[0].originData
                if rankList.count > 1 {
                    self.theSort2UserInfoView.rankData = rankList[1].originData;
                } else {
                    self.theSort2UserInfoView.rankData = nil;
                    self.theSort3UserInfoView.rankData = nil;
                }
                if rankList.count > 2 {
                    self.theSort3UserInfoView.rankData = rankList[2].originData;
                } else {
                    self.theSort3UserInfoView.rankData = nil;
                }
            }
            
        }
    }
    var rankType: SDRankType {
        didSet {
            self.theSort1UserInfoView.rankType = self.rankType;
            self.theSort2UserInfoView.rankType = self.rankType;
            self.theSort3UserInfoView.rankType = self.rankType;
        }
    }

    init(_ type: SDRankType) {
        self.rankType = type;
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

private extension SDRankSortView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgImageView).width(100%).height(370~).position(.absolute).bottom(0).left(0);
            flex.addItem(self.theSort2ImageView).width(176~).height(148~).position(.absolute).left(76~).top(102~);
            flex.addItem(self.theSort1ImageView).width(206~).height(184~).position(.absolute).left(280~);
            flex.addItem(self.theSort3ImageView).width(176~).height(148~).position(.absolute).top(104~).right(60~);
            flex.addItem(self.theSort2UserInfoView).width(168~).height(176~).position(.absolute).left(94~).top(274~);
            flex.addItem(self.theSort1UserInfoView).width(168~).height(176~).position(.absolute).left(288~).top(222~);
            flex.addItem(self.theSort3UserInfoView).width(168~).height(176~).position(.absolute).right(78~).top(278~);
        }
    }
}
