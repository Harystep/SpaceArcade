//
//  SDRankSortUserInfoView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SDWebImage

enum SDRankType {
    case sortKind
    case sortFortune
}

class SDRankSortUserInfoView: UIView {
    fileprivate let rootFlexContainer: UIView = UIView();
    
    
    lazy var theAvatarView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_default_avatar"))
        return theView;
    }()
    
    lazy var theNameLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 28)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    lazy var theValueLogoView: UIImageView = {
        var image : UIImage? = nil;
        if self.rankType == .sortKind {
            image = UIImage(named: "space_coin_icon");
        } else {
            image = UIImage(named: "ico_rank_fortune_logo");
        }
        
        let theView = UIImageView(image: image);
        return theView;
    }()
    
    lazy var theValueLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.textColor = UIColor.init(hex: 0xEEAA29);
        return theView;
    }()
    
    
    var rankData: SDSummaryRankData? {
        didSet {
            if self.rankData != nil {
                self.theAvatarView.sd_setImage(with: URL(string: self.rankData!.avatar), placeholderImage: UIImage(named: "ico_default_avatar"), context: nil);
                
                self.theNameLabel.text = self.rankData!.nickName;
            
                if self.rankData!.total > 1000 {
                    let valuePres = self.rankData!.total % 1000;
                    if valuePres > 0 {
                        self.theValueLabel.text = String.init(format: "%.2fK", Float(self.rankData!.total) * 1.0 / 1000)
                    } else {
                        self.theValueLabel.text = String.init(format: "%ldK", Float(self.rankData!.total) / 1000)
                    }
                } else  {
                    self.theValueLabel.text = "\(self.rankData!.total)";
                }
                self.theValueLogoView.isHidden = false;
            } else {
                self.theValueLogoView.isHidden = true;
                self.theAvatarView.image = nil;
                self.theNameLabel.text = "";
                self.theValueLabel.text = "";
            }
            
            
            self.theNameLabel.flex.markDirty();
            self.theValueLabel.flex.markDirty();
            self.rootFlexContainer.flex.layout();
        }
    }
    var rankType: SDRankType {
        didSet {
            var image : UIImage? = nil;
            if self.rankType == .sortKind {
                image = UIImage(named: "space_coin_icon");
            } else {
                image = UIImage(named: "ico_rank_fortune_logo");
            }
            self.theValueLogoView.image = image;
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
        self.theAvatarView.layer.masksToBounds = true;
        self.theAvatarView.layer.cornerRadius = self.theAvatarView.frame.size.height / 2.0;
    }

}
private extension SDRankSortUserInfoView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.direction(.column).alignItems(.center).define { [unowned self] flex in
            flex.addItem(self.theAvatarView).width(86~).height(86~);
            flex.addItem(self.theNameLabel);
            flex.addItem().direction(.row).alignItems(.center).define { [unowned self] flex in
                flex.addItem(self.theValueLogoView).width(32~).height(32~)
                flex.addItem(self.theValueLabel);
            }
        }
    }
}
