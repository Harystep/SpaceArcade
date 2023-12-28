//
//  SDGameVideoView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/22.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize


protocol SDGameVideoViewType {
    func startPlayStream(_ machineSn: String);
    func shutdown();
}

class SDGameVideoView: UIView {

    fileprivate let rootFlexController = UIView();
    
    lazy var theFlvView: SDRTCView = {
        let theView = SDRTCView.init();
        return theView;
    }()
    
    lazy var theLeftSideImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_def_left"))
        return theView;
    }()
    
    lazy var theRightSideImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_def_right"));
        return theView;
    }()
    
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
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%)
        self.rootFlexController.flex.layout();
    }
}

private extension SDGameVideoView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.define { [unowned self] flex in
            flex.addItem(self.theFlvView).width(100%).height(100%)
            flex.addItem(self.theLeftSideImageView).width(144~).height(100%).position(.absolute).left(0).top(0);
            flex.addItem(self.theRightSideImageView).width(144~).height(100%).position(.absolute).right(0).top(0);
        }
    }
}

extension SDGameVideoView: SDGameVideoViewType {
    func shutdown() {
        self.theFlvView.shutdown();
    }
    func startPlayStream(_ machineSn: String) {
        self.theFlvView.setVideoUrl(machineSn);
    }
    func muteSteam(_ mute: Bool) {
        self.theFlvView.muteVideo(mute);        
    }
}
