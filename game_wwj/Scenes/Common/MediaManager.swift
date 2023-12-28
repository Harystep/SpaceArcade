//
//  MediaManager.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/23.
//

import UIKit

import EZPlayer
class MediaManager {
     var player: EZPlayer?
     var mediaUrl : URL?
     var embeddedContentView: UIView?

    static let sharedInstance = MediaManager()
    private init(){

        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidPlayToEnd(_:)), name: .EZPlayerPlaybackDidFinish, object: nil)

    }

    func playEmbeddedVideo(url: URL, embeddedContentView contentView: UIView? = nil, userinfo: [AnyHashable : Any]? = nil) {
        var mediaUrl = url;
        self.playEmbeddedVideo(mediaUrl: mediaUrl, embeddedContentView: contentView, userinfo: userinfo )

    }

    func playEmbeddedVideo(mediaUrl: URL, embeddedContentView contentView: UIView? = nil , userinfo: [AnyHashable : Any]? = nil ) {
        //stop
        self.releasePlayer()

        if let skinView = userinfo?["skin"] as? UIView{
         self.player =  EZPlayer(controlView: skinView)
        }else{
          self.player = EZPlayer()
        }
//        self.player?.backButtonBlock

//        self.player!.slideTrigger = (left:EZPlayerSlideTrigger.none,right:EZPlayerSlideTrigger.none)

        if let autoPlay = userinfo?["autoPlay"] as? Bool{
            self.player!.autoPlay = autoPlay
        }

        if let floatMode = userinfo?["floatMode"] as? EZPlayerFloatMode{
            self.player!.floatMode = floatMode
        }

        if let fullScreenMode = userinfo?["fullScreenMode"] as? EZPlayerFullScreenMode{
            self.player!.fullScreenMode = fullScreenMode
        }

        self.player!.backButtonBlock = { fromDisplayMode in
            if fromDisplayMode == .embedded {
                self.releasePlayer()
            }else if fromDisplayMode == .fullscreen {
                if self.embeddedContentView == nil && self.player!.lastDisplayMode != .float{
                    self.releasePlayer()
                }

            }else if fromDisplayMode == .float {
                if self.player!.lastDisplayMode == .none{
                    self.releasePlayer()
                }
            }

        }

        self.embeddedContentView = contentView

        self.player!.playWithURL(mediaUrl , embeddedContentView: self.embeddedContentView)
    }




    func releasePlayer(){
        self.player?.stop()
        self.player?.view.removeFromSuperview()

        self.player = nil
        self.embeddedContentView = nil
        self.mediaUrl = nil

    }

    @objc  func playerDidPlayToEnd(_ notifiaction: Notification) {
       //结束播放关闭播放器
       //self.releasePlayer()

    }




}
