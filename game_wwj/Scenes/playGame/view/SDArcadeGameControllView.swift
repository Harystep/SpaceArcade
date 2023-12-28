//
//  SDArcadeGameControllView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/17.
//

import FlexLayout
import PinLayout
import SwiftHEXColors
import SwiftyFitsize
import UIKit

import RxCocoa
import RxSwift

protocol SDArcadeGameControllViewType {
    /// 更新 账号信息的 UI
    func updateMoneyViewLayout()
    /// 目前游戏中的人列表的 UI
    func updateCurrentSeatPlayerListView()
    /// 更新 围观人的 UI
    func updateOnlookerPlayerView()
}

class SDArcadeGameControllView: UIView {
    fileprivate let rootFlexController = UIView()
    
    // MARK: - UI

    lazy var theCloseButton: UIButton = {
        let theView = UIButton()
        theView.setImage(UIImage(named: "icon_game_exit"), for: .normal)
        return theView
    }()
    
    lazy var theAvatarView: UIImageView = {
        let theView = UIImageView();
        return theView;
    }()
    
    lazy var theGameMoneyForCoinView: SDGameMoneyView = {
        let theView = SDGameMoneyView(type: .moneyForCoin)
        return theView
    }()
    
    lazy var theGameMoneyForPointView: SDGameMoneyView = {
        let theView = SDGameMoneyView(type: .moneyForPoint)
        return theView
    }()
    
    lazy var theDefineGmaeFlexController: UIView = {
        let theView = UIView()
        return theView
    }()
    
    lazy var theWaitSeatPlayerView: SDCurrentSeatPlayerView = {
        let theView = SDCurrentSeatPlayerView()
        return theView
    }()
    
    lazy var theOnlookerPlayerView: SDArcadeOnlookerPlayersView = {
        let theView = SDArcadeOnlookerPlayersView()
        return theView
    }()
    
    lazy var theAwaitSeatBtView: SDAwaitSeatBtView = {
        let theView = SDAwaitSeatBtView()
        return theView
    }()
    
    lazy var theGameControlFlexController: UIView = {
        let theView = UIView()
        return theView
    }()
    
    lazy var theSeatPlayerView: SDSeatPlayersView = {
        let theView = SDSeatPlayersView.init();
        return theView;
    }()
    
    lazy var theGameDirctionView: SDSeatGameDirectionControlView = {
        let theView = SDSeatGameDirectionControlView();
        return theView;
    }()
    
    lazy var theGameActionView: SDSeatGameActionView = {
        let theView = SDSeatGameActionView();
        return theView;
    }()
    
    lazy var theGameFuncListView: SDGameInFuncListView = {
        let theView = SDGameInFuncListView()
        return theView;
    }()
    
    // MARK: - data

    /// 目前游戏的 状态
    var gamingStatus: SDGamePlayStatus = .define {
        didSet {
            if self.gamingStatus == .selfPlaying {
                self.theDefineGmaeFlexController.isHidden = true
                self.theGameControlFlexController.isHidden = false
            } else {
                self.theDefineGmaeFlexController.isHidden = false
                self.theGameControlFlexController.isHidden = true
            }
            self.theGameFuncListView.gamingStatus = self.gamingStatus;
        }
    }
    
    /// 目前游戏在什么位置
    var seatPlayIndex: Int = 0;
    
    init() {
        super.init(frame: CGRect.zero)
        self.configView()
        self.gamingStatus = .define;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.rootFlexController.pin.left().top().height(100%).width(100%)
        self.theGameDirctionView.flex.marginLeft(self.safeAreaInsets.left);
        self.theSeatPlayerView.flex.marginLeft(self.safeAreaInsets.left + 16~);
        self.rootFlexController.flex.layout()
        
        self.theAvatarView.layer.masksToBounds = true;
        self.theAvatarView.layer.cornerRadius = 26~;
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SDArcadeGameControllView {
    func configView() {
        self.addSubview(self.rootFlexController)
        
        self.rootFlexController.flex.direction(.column).define { [unowned self] flex in
            
            
            /// 默认情况
            flex.addItem().position(.absolute)
                .direction(.column)
                .justifyContent(.spaceBetween)
                .left(0)
                .top(21~)
                .width(100%)
                .height(100%).define { [unowned self] flex in
                    flex.addItem().direction(.row).justifyContent(.center).alignItems(.center).height(100~).width(100%).define { flex in
//                        flex.addItem(self.theWaitSeatPlayerView).height(100%)
                        flex.addItem(self.theOnlookerPlayerView).position(.absolute).height(72~).right(22~)
                    }
                }
            flex.addItem(self.theDefineGmaeFlexController)
                .position(.absolute)
                .direction(.column)
                .justifyContent(.spaceBetween)
                .left(0)
                .top(21~)
                .width(100%)
                .height(100%)
                .define { [unowned self] flex in
                    flex.addItem().direction(.row).justifyContent(.center).alignItems(.center).height(100~).width(100%)
                    flex.addItem(self.theAwaitSeatBtView).width(100%).height(100~).marginBottom(60~)
                }
            
            /// 游戏中
            flex.addItem(self.theGameControlFlexController)
                .position(.absolute)
                .direction(.column)
                .left(0).top(0)
                .right(86~)
                .height(100%)
                .define { [unowned self] flex in
                    flex.addItem(self.theSeatPlayerView).width(100%).height(140~).marginTop(96~);
                    flex.addItem().width(100%).grow(1).direction(.row).alignItems(.center).marginTop(-100~).justifyContent(.spaceBetween).define { [unowned self] flex in
                        flex.addItem(self.theGameDirctionView).size(CGSize(width: 280~, height: 280~)).marginTop(100~);
                        flex.addItem(self.theGameActionView).width(200~).marginRight(40~);
                    }
                }
            // 顶部 返回
            flex.addItem().padding(14~).height(110~).width(70%).define { [unowned self] flex in
                flex.addItem().direction(.row).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theCloseButton).width(64~).height(64~)
                    flex.addItem(self.theAvatarView).width(52~).height(52~);
                    flex.addItem(self.theGameMoneyForCoinView).height(48~).marginLeft(21~)
                    flex.addItem(self.theGameMoneyForPointView).height(48~).marginLeft(12~)
                    flex.addItem(self.theGameFuncListView).marginLeft(28~);
                }
            }
        }
    }
}

extension SDArcadeGameControllView: SDArcadeGameControllViewType {
    func updateOnlookerPlayerView() {
        self.theOnlookerPlayerView.displayPlayersView()
        self.theOnlookerPlayerView.flex.markDirty()
        setNeedsLayout()
    }
    
    func updateCurrentSeatPlayerListView() {
        self.theWaitSeatPlayerView.flex.markDirty()
        setNeedsLayout()
    }
    
    func updateMoneyViewLayout() {
        self.theGameMoneyForCoinView.flex.markDirty()
        self.theGameMoneyForPointView.flex.markDirty()
        setNeedsLayout()
    }
}

extension Reactive where Base: SDArcadeGameControllView {
    /// Bindable sink for `text` property.
    var gamingStatus: Binder<SDGamePlayStatus> {
        return Binder(self.base) { view, status in
            view.gamingStatus = status
        }
    }
}
