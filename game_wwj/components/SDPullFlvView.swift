//
//  SDPullFlvView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/22.
//

import UIKit

//import IJKMediaFramework


protocol SDPullFlvViewType {
    func setVideoUrl(_ url: String);
    func shutdown();
}

class SDPullFlvView: UIView {

//    var palyer: IJKFFMoviePlayerController?;

    var videoUrl: String?
    
    init() {
        super.init(frame: CGRectZero);
    }
    
    init(_ url: String) {
        videoUrl = url;
        super.init(frame: CGRectZero);
        self.configView();
    }
    override init(frame: CGRect) {
        videoUrl = "";
        super.init(frame: frame);
        self.configView();
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SDPullFlvView: SDPullFlvViewType {
    func shutdown() {
//        self.palyer?.shutdown();
    }
    
    func setVideoUrl(_ url: String) {
        let flvUrl = "http://play-test.ssjww100.com/live/wwj_zego_stream_\(url).flv";
        self.videoUrl = url;
        self.configView();
    }
    
    
}
private extension SDPullFlvView {
    func configView() {
//        guard let options = IJKFFOptions.byDefault() else {return}
//        options.setOptionIntValue(500, forKey: "analyzemaxduration", of: kIJKFFOptionCategoryFormat)
//        options.setOptionIntValue(1024 * 16, forKey: "probesize", of: kIJKFFOptionCategoryFormat)
//        options.setOptionIntValue(1, forKey: "flush_packets", of: kIJKFFOptionCategoryFormat)
//        options.setOptionIntValue(0, forKey: "http-detect-range-support", of: kIJKFFOptionCategoryFormat)
//        options.setOptionValue("tcp", forKey: "rtsp_transport", of: kIJKFFOptionCategoryFormat);
//        options.setOptionIntValue(1, forKey: "rtmp_buffer", of: kIJKFFOptionCategoryFormat)
//        options.setOptionIntValue(1000, forKey: "rtmp_buffer_size", of: kIJKFFOptionCategoryFormat)
//        options.setOptionIntValue(1, forKey: "enable-accurate-seek", of: kIJKFFOptionCategoryPlayer);
//        options.setOptionIntValue(1, forKey: "framedrop", of: kIJKFFOptionCategoryPlayer);
//        options.setOptionIntValue(0, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer);
//        options.setOptionIntValue(1, forKey: "mediacodec-hevc", of: kIJKFFOptionCategoryPlayer);
//        options.setOptionIntValue(0, forKey: "mediacodec", of: kIJKFFOptionCategoryPlayer);
//        options.setOptionIntValue(1, forKey: "fast", of: kIJKFFOptionCategoryPlayer);
//
//        options.setCodecOptionIntValue(0, forKey: "skip_loop_filter")
//        options.setCodecOptionIntValue(1, forKey: "skip_frame")
//        options.setCodecOptionIntValue(10, forKey: "max_cached_duration")
//        options.setCodecOptionIntValue(1, forKey: "infbuf")
//        options.setCodecOptionIntValue(0, forKey: "packet-buffering")
//
//        self.palyer = IJKFFMoviePlayerController.init(contentURL: URL(string: self.videoUrl!), with: options);
//        if let videoPlayer = self.palyer {
//            videoPlayer.view.autoresizingMask = .flexibleHeight;
//
//            videoPlayer.view.frame = self.bounds;
//
//            videoPlayer.scalingMode = .aspectFit;
//            videoPlayer.shouldAutoplay = true;
//            videoPlayer.prepareToPlay();
//            self.addSubview(videoPlayer.view);
//        }
    }
}
