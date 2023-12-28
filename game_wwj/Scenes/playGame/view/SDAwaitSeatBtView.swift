//
//  SDAwaitSeatBtView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/18.
//

import UIKit
import PinLayout
import FlexLayout
import SwiftyFitsize

import RxCocoa
import RxSwift


class SDAwaitSeatBtView: UIView {
    
    fileprivate let rootFlexController = UIView();
    
    lazy var theSeatPlayerBt1: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage.init(named: "icon_player_1"), for: .normal);
        theView.tag = 1;
        return theView;
    }()
    lazy var theSeatPlayerBt2: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage.init(named: "icon_player_2"), for: .normal);
        theView.tag = 2;
        return theView;
    }()
    lazy var theSeatPlayerBt3: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage.init(named: "icon_player_3"), for: .normal);
        theView.tag = 3;
        return theView;
    }()
    lazy var theSeatPlayerBt4: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage.init(named: "icon_player_4"), for: .normal);
        theView.tag = 4;
        return theView;
    }()
    
    
    let onTapSeatPlay: PublishSubject<Int> = PublishSubject<Int>();
    
    var seatPlayerList: [SDSaintSeatInfoData] = [] {
        didSet {
            self.theSeatPlayerBt1.isHidden = false;
            self.theSeatPlayerBt2.isHidden = false;
            self.theSeatPlayerBt3.isHidden = false;
            self.theSeatPlayerBt4.isHidden = false;
            self.seatPlayerList.forEach { data in
                if data.position == 1 {
                    self.theSeatPlayerBt1.isHidden = true;
                } else if data.position == 2 {
                    self.theSeatPlayerBt2.isHidden = true;
                } else if data.position == 3 {
                    self.theSeatPlayerBt3.isHidden = true;
                } else if data.position == 4 {
                    self.theSeatPlayerBt4.isHidden = true;
                }
            }
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
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%)
        self.rootFlexController.flex.layout();
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension SDAwaitSeatBtView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController
            .flex
            .direction(.row)
            .alignItems(.center)
            .justifyContent(.spaceBetween)
            .paddingHorizontal(134~)
            .define { [unowned self] flex in
            flex.addItem(self.theSeatPlayerBt1).width(184~).height(66~);
            flex.addItem(self.theSeatPlayerBt2).width(184~).height(66~);
            flex.addItem(self.theSeatPlayerBt3).width(184~).height(66~);
            flex.addItem(self.theSeatPlayerBt4).width(184~).height(66~);
        }
        
        self.theSeatPlayerBt1.addTarget(self, action: #selector(onTapSeatPlayPress(_:)), for: .touchUpInside);
        self.theSeatPlayerBt2.addTarget(self, action: #selector(onTapSeatPlayPress(_:)), for: .touchUpInside);
        self.theSeatPlayerBt3.addTarget(self, action: #selector(onTapSeatPlayPress(_:)), for: .touchUpInside);
        self.theSeatPlayerBt4.addTarget(self, action: #selector(onTapSeatPlayPress(_:)), for: .touchUpInside);
    }
    
    @objc func onTapSeatPlayPress(_ sender: UIButton) {
        self.onTapSeatPlay.onNext(sender.tag);
    }
}

extension Reactive where Base: SDAwaitSeatBtView {
    /// Bindable sink for `text` property.
    var seatPlayerList: Binder<[SDSaintSeatInfoData]> {
        return Binder(self.base) { view, list in
            view.seatPlayerList = list;
        }
    }
}
