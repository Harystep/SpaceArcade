//
//  SDAvatarView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/11.
//

import UIKit

import FlexLayout
import SDWebImage

protocol SDAvatarViewType {
    
}

class SDAvatarView: UIView {
    
    var avatarUrl: String = "" {
        didSet {
            self.theImageView.sd_setImage(with: URL(string: avatarUrl));
        }
    }
    
    lazy var theImageView: UIImageView = {
        let theView = UIImageView.init();
        return theView;
    }()
    
    init() {
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.flex.layout();
        
        let rootLayout = CAShapeLayer.init();
        rootLayout.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.frame.size.height / 2.0).cgPath;
        self.layer.mask = rootLayout;
        
        let imageLayout = CAShapeLayer.init();
        imageLayout.path = UIBezierPath.init(roundedRect: self.theImageView.bounds, cornerRadius: self.theImageView.bounds.size.height / 2.0).cgPath;
        self.theImageView.layer.mask = imageLayout;
        
    }
}
private extension SDAvatarView {
    func configView() {
        self.backgroundColor = UIColor.white;
        self.flex.padding(2).define { [unowned self] flex in
            flex.addItem(self.theImageView).width(100%).height(100%);
        }
    }
}
