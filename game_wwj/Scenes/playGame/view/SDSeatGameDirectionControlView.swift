//
//  SDSeatGameDirectionControlView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/21.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

import RxSwift
import RxCocoa

import pop

enum SDGameDirctionForType: Int {
    case dirctionNone = 0
    case dirctionUp = 1
    case dirctionDown = 2
    case dirctionLeft = 3
    case dirctionRight = 4
}

class SDSeatGameDirectionControlView: UIView {
    
    // MARK: - UI
    lazy var theDirctionBgView: UIImageView = {
        let theView = UIImageView()
        theView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 280~, height: 280~));
        return theView;
    }()
    
    lazy var theDirctionLeftImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_control_left"))
        theView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 84~, height: 84~));
        return theView;
    }()
    
    lazy var theDirctionUpImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_control_up"));
        theView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 84~, height: 84~));
        return theView;
    }()
    lazy var theDirctionRightImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_control_right"))
        theView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 84~, height: 84~));
        return theView;
    }()
    
    lazy var theDirctionDownImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_control_down"))
        theView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 84~, height: 84~));
        return theView;
    }()
    
    // MARK: - ViewModel
    
    let touchDirctionTrigger: PublishSubject<SDGameDirctionForType> = PublishSubject<SDGameDirctionForType>();
        
    init() {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 280~, height: 280~)));
        self.configView();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self);
            self.touchBegan(point);
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self);
            self.touchMoved(point);
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self);
            self.touchEnd(point);
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self);
            self.touchEnd(point);
        }
    }
}
private extension SDSeatGameDirectionControlView {
    func configView() {
        self.addSubview(self.theDirctionBgView);
        
        self.addSubview(self.theDirctionUpImageView);
        self.addSubview(self.theDirctionDownImageView);
        self.addSubview(self.theDirctionLeftImageView);
        self.addSubview(self.theDirctionRightImageView);
        
        self.theDirctionLeftImageView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: (self.frame.size.height - self.theDirctionLeftImageView.frame.size.height) / 2.0), size: self.theDirctionLeftImageView.frame.size);
        
        self.theDirctionUpImageView.frame = CGRect(origin: CGPoint.init(x: (self.frame.size.width - self.theDirctionUpImageView.frame.size.width) / 2.0 + 1.0, y: 0), size: self.theDirctionUpImageView.frame.size);
        
        self.theDirctionRightImageView.frame = CGRect(origin: CGPoint(x: self.frame.self.width - self.theDirctionRightImageView.frame.size.width, y: (self.frame.size.height - self.theDirctionRightImageView.frame.size.height) / 2.0), size: self.theDirctionRightImageView.frame.size);
    
        self.theDirctionDownImageView.frame = CGRect(origin: CGPoint.init(x: (self.frame.size.width - self.theDirctionUpImageView.frame.size.width) / 2.0, y: self.frame.size.height - self.theDirctionDownImageView.frame.size.height), size: self.theDirctionDownImageView.frame.size);
        
    }
    func touchBegan(_ touch_point: CGPoint) {
        let dirction = self.getDirctionFromPoint(touch_point);
        log.debug("[touchBegan] dirction ---> \(dirction)")
        self.showDirctionImageView(dirction);
        
        self.touchDirctionTrigger.onNext(dirction);
        
    }
    func touchMoved(_ touch_point: CGPoint) {
        
    }
    func touchEnd(_ touch_point: CGPoint) {
        let dirction = self.getDirctionFromPoint(touch_point);
        self.hideDirctionImageView(dirction);
    }
    
    func getAngleFromPoint(_ point: CGPoint) -> Double {
        let centerPoint = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0);
        let offsetX = point.x - centerPoint.x;
        let offsetY = point.y - centerPoint.y;
        var tanX = 0.0;
        if offsetX == 0 {
            if centerPoint.y > point.y {
                tanX = Double.pi / 2.0;
            } else {
                tanX = Double.pi / 2.0 * 3.0;
            }
        } else {
            tanX = atan((offsetY / offsetX));
        }
        if point.x < centerPoint.x && point.y > centerPoint.y {
            tanX = Double.pi + tanX;
        } else if point.x < centerPoint.x && point.y < centerPoint.y {
            tanX = Double.pi + tanX;
        }
        return tanX;
    }
    
    func getDirctionFromPoint(_ point: CGPoint) -> SDGameDirctionForType {
        let angle = self.getAngleFromPoint(point);
        var actionType: SDGameDirctionForType = .dirctionNone;
        if (angle > 0 && angle < Double.pi / 4.0) {
            actionType = .dirctionRight;
        } else if (angle >= Double.pi / 4.0 && angle < Double.pi / 4.0 * 3) {
            actionType = .dirctionDown;
        } else if (angle >= Double.pi / 4.0 * 3 && angle < Double.pi / 4.0 * 5) {
            actionType = .dirctionLeft;
        } else if (angle >= Double.pi / 4.0 * 5 && angle < Double.pi / 4.0 * 7) {
            actionType = .dirctionUp;
        } else if (angle >= Double.pi / 4.0 * 7){
            actionType = .dirctionRight;
        } else if (angle <= 0 && angle > -Double.pi / 4.0) {
            actionType = .dirctionRight;
        } else if (angle <= -Double.pi / 4.0 && angle >= -Double.pi / 2.0) {
            actionType = .dirctionUp;
        }
        return actionType;
    }
    
    func showDirctionImageView(_ dirction: SDGameDirctionForType) {
        var theDirctionView: UIImageView? = nil;
        switch dirction {
        case .dirctionUp:
            theDirctionView = self.theDirctionUpImageView;
        case .dirctionDown:
            theDirctionView = self.theDirctionDownImageView;
        case .dirctionLeft:
            theDirctionView = self.theDirctionLeftImageView;
        case .dirctionRight:
            theDirctionView = self.theDirctionRightImageView;
        default: break;
        }
        
//        if theDirctionView != nil {
//            let showAnimation = POPSpringAnimation(propertyNamed: kPOPViewAlpha);
//            showAnimation?.toValue = 1;
//            showAnimation?.fromValue = 0;
//            theDirctionView?.pop_add(showAnimation, forKey: "show_pop_animation");
//        }
    }
    func hideDirctionImageView(_ dirction: SDGameDirctionForType) {
        var theDirctionView: UIImageView? = nil;
        switch dirction {
        case .dirctionUp:
            theDirctionView = self.theDirctionUpImageView;
        case .dirctionDown:
            theDirctionView = self.theDirctionDownImageView;
        case .dirctionLeft:
            theDirctionView = self.theDirctionLeftImageView;
        case .dirctionRight:
            theDirctionView = self.theDirctionRightImageView;
        default: break;
        }
//        if theDirctionView != nil {
//            let hideAnimation = POPSpringAnimation(propertyNamed: kPOPViewAlpha);
//            hideAnimation?.toValue = 0;
//            hideAnimation?.fromValue = 1;
//            theDirctionView?.pop_add(hideAnimation, forKey: "hide_pop_animation");
//        }
    }
}
