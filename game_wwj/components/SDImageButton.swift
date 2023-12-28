//
//  SDImageButton.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/22.
//

import UIKit

class SDImageButton: UIControl {

    lazy var imageView: UIImageView = {
        let theView = UIImageView.init()
        theView.isUserInteractionEnabled = false;
        return theView;
    }()
    
    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    
    init(_ image: UIImage?) {
        super.init(frame: CGRectZero);
        self.configView();
        self.imageView.image = image;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.imageView.frame = self.bounds;
    }
}

private extension SDImageButton {
    func configView() {
        self.addSubview(self.imageView);
    }
}
