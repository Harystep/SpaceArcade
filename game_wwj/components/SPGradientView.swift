//
//  SPGradientView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/15.
//

import UIKit

class SPGradientView: UIView {
    
    let colors: [Any];
    let startPoint: CGPoint;
    let endPoint: CGPoint;
    
    init(_ colors: [Any], _ startPoint: CGPoint, _ endPoint: CGPoint) {
        self.colors = colors;
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        super.init(frame: CGRect.zero);
        self.configView();
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let theLayer = CAGradientLayer()
        theLayer.colors = self.colors;
        theLayer.startPoint = self.startPoint;
        theLayer.endPoint = self.endPoint;
        return theLayer;
    }()
    
    override init(frame: CGRect) {
        self.colors = [UIColor.white];
        self.startPoint = CGPoint.zero;
        self.endPoint = CGPoint(x: 1, y: 0);
        super.init(frame: frame);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.gradientLayer.frame = self.bounds;
    }
}
private extension SPGradientView {
    func configView() {
        self.layer.addSublayer(self.gradientLayer);
    }
}
