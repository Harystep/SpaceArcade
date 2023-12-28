//
//  SDFoldingAvatarView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/17.
//

import UIKit

import SDWebImage
import SwiftyFitsize

class SDFoldingAvatarView: UIView {
    
    var avatarList: [String] = [] {
        didSet {
            self.updateDisplayUserAvatarList();
        }
    }

    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.configView();
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension SDFoldingAvatarView {
    func configView() {
        
    }
    func updateDisplayUserAvatarList() {
        
        self.subviews.forEach { view in
            view.removeFromSuperview();
        }
        var maxOriginX = 0.0;
        for i in 0..<self.avatarList.count {
            let avatarUrl = self.avatarList[i];
            let theView = self.getAvatarImageView(avatar: avatarUrl);
            self.addSubview(theView);
            theView.frame.origin.x = CGFloat(i) * 22~;
            maxOriginX = theView.frame.maxX;
        }
        
        self.frame.size.width = maxOriginX;
    }
    
    func getAvatarImageView(avatar: String) -> UIImageView {
        let theView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 52~, height: 52~));
//        theView.sd_setImage(with: URL(string: avatar));
        theView.sd_setImage(with: URL(string: avatar), placeholderImage: UIImage(named: "ico_default_avatar"), context: nil);
        theView.layer.masksToBounds = true;
        theView.layer.cornerRadius = 26~;
        return theView;
    }
}
