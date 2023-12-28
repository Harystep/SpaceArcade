//
//  SDSeatPlayersView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/19.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors

import RxSwift
import RxCocoa

class SDSeatPlayersView: UIView {
    
    fileprivate let rootFlexController = UIView();
    
    lazy var theSeatPlayer1: SDSettlementSeatPlayerView = {
        let theView = SDSettlementSeatPlayerView(1);
        theView.tag = 1;
        return theView
    }()
    lazy var theSeatPlayer2: SDSettlementSeatPlayerView = {
        let theView = SDSettlementSeatPlayerView(2);
        theView.tag = 2;
        return theView
    }()
    lazy var theSeatPlayer3: SDSettlementSeatPlayerView = {
        let theView = SDSettlementSeatPlayerView(3);
        theView.tag = 3;
        return theView
    }()
    lazy var theSeatPlayer4: SDSettlementSeatPlayerView = {
        let theView = SDSettlementSeatPlayerView(4);
        theView.tag = 4;
        return theView
    }()
    
    let onSettlementSeatPress: PublishSubject<Void> = PublishSubject<Void>();
    
    var seatPlayers: [SDSaintSeatInfoData] = [] {
        didSet {
            self.seatPlayers.forEach { item in
                if item.position == 1 {
                    self.theSeatPlayer1.seatInfo = item;
                } else if item.position == 2 {
                    self.theSeatPlayer2.seatInfo = item;
                } else if item.position == 3 {
                    self.theSeatPlayer3.seatInfo = item;
                } else if item.position == 4 {
                    self.theSeatPlayer4.seatInfo = item;
                }
            }
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.configView();
        self.configData();
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.configView();
        self.configData();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().right().width(100%).height(100~);
        self.rootFlexController.flex.layout();
    }
}
private extension SDSeatPlayersView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.direction(.column).define { [unowned self] flex in
            flex.addItem().direction(.row).paddingRight(20~).define { [unowned self] flex in
                flex.addItem(self.theSeatPlayer1).width(78~).height(133~);
                flex.addItem(self.theSeatPlayer2).width(78~).height(133~).marginLeft(18~);
                flex.addItem(self.theSeatPlayer3).width(78~).height(133~).marginLeft(18~);
                flex.addItem(self.theSeatPlayer4).width(78~).height(133~).marginLeft(18~);
            }
        }
    }
    func configData() {
        self.theSeatPlayer1.addTarget(self, action: #selector(onSettlementPress(_:)), for: .touchUpInside);
        self.theSeatPlayer2.addTarget(self, action: #selector(onSettlementPress(_:)), for: .touchUpInside);
        self.theSeatPlayer3.addTarget(self, action: #selector(onSettlementPress(_:)), for: .touchUpInside);
        self.theSeatPlayer4.addTarget(self, action: #selector(onSettlementPress(_:)), for: .touchUpInside);
    }
    @objc func onSettlementPress(_ sender: UIControl) {
        
        log.debug("[结算] -----> ");
        self.onSettlementSeatPress.onNext(());
    }
}
extension Reactive where Base: SDSeatPlayersView {
    /// Bindable sink for `seatPlayers` property.
    internal var seatPlayers: Binder< [SDSaintSeatInfoData]> {
        return Binder(self.base) { view, list in
            view.seatPlayers = list;
        }
    }
}
