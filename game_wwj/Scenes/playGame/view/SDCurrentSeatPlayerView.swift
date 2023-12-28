//
//  SDCurrentSitPlayerView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/17.
//

import UIKit

import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

import RxSwift
import RxCocoa

class SDCurrentSeatPlayerView: UIView {
    
    var seatPlayers: [SDSaintSeatInfoData] = [] {
        didSet {
            self.updateSeatInfoPlayersView();
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

private extension SDCurrentSeatPlayerView {
    func configView() {
        
    }
    
    func updateSeatInfoPlayersView() {
        
        self.subviews.forEach { view in
            view.removeFromSuperview();
        }
        var maxOriginX = 0.0;
        for i in 0 ..< self.seatPlayers.count {
            let seat = self.seatPlayers[i];
            let view = SDSeatPlayerView(seat.position);
            view.playerInfo = seat;
            self.addSubview(view);
            
            view.frame = CGRect.init(x: maxOriginX, y: 0, width: 78~, height: 99~);
            maxOriginX += 97~;
        }
        self.frame.size.width = maxOriginX + 78~;
    }
}

extension Reactive where Base: SDCurrentSeatPlayerView {
    
    /// Bindable sink for `text` property.
    internal var seatPlayers: Binder<[SDSaintSeatInfoData]> {
        return Binder(self.base) { view, list in
            view.seatPlayers = list.sorted(by: {
                return $0.position < $1.position;
            })
        }
    }
}
