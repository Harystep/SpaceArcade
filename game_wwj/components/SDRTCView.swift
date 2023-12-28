//
//  SDRTCView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/25.
//

import UIKit
import WsRTC


class SDRTCView: UIView {

    lazy var videoView: WsRTCLiveView = {
        let theView = WsRTCLiveView.init(frame: CGRectZero, audioforamt: .AAC_LATM, encrypt: false);
        return theView;
    }()
    var videoControllerView : WsRTCLiveView? = nil;
    var videoMute: Bool = false;
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
        self.videoView.frame = self.bounds;
    }
}
private extension SDRTCView {
    func configView() {
        self.addSubview(self.videoView);
        self.videoView.setRenderMode(.videoRenderMode_ScaleAspect_FIT);
        self.videoView.delegate = self;
    }
}
extension SDRTCView: SDPullFlvViewType {
    func setVideoUrl(_ url: String) {
        let videoUrl = "http://play-test.ssjww100.com/live/wwj_zego_stream_\(url).sdp"
        self.videoView.streamUrl = videoUrl;
        self.videoView.startplay();
    }
    
    func shutdown() {
        self.videoView.stop();
    }
    func muteVideo(_ mute: Bool) {
        self.videoMute = mute;
        DispatchQueue.main.async {
            if mute == true {
                self.videoView.setVolume(0.01)
            } else {
                self.videoView.setVolume(1.0)
            }
        }
    }
}

extension SDRTCView: WsRTCLiveViewDelegate {
    func videoView(_ videoView: WsRTCLiveView, didChangeVideoSize size: CGSize) {
        
    }
    func videoView(_ videoView: WsRTCLiveView, didError error: Error) {
        
    }
    func onConnected(_ videoView: WsRTCLiveView) {
//        videoControllerView = videoView;
        videoView.setAudioMute(self.videoMute);
    }
}
