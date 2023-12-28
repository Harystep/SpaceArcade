//
//  SDArcadeGameViewController.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import SwiftHEXColors
import SwiftyFitsize
import UIKit
import SPIndicator
import ProgressHUD
import MediaPlayer

class SDArcadeGameViewController: SDBaseGameViewController, ViewModelAttaching {
    fileprivate let rootFlexController = UIView()
    override var prefersHomeIndicatorAutoHidden: Bool {true}
    lazy var theControlView: SDArcadeGameControllView = {
        let theView = SDArcadeGameControllView()
        return theView
    }()
    
    lazy var theGameVideo: SDGameVideoView = {
        let theView = SDGameVideoView();
        return theView;
    }()
    
    override init(machineSn: String, machineType: Int) {
        super.init(machineSn: machineSn, machineType: machineType);
        self.configView();
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.screenOrientationRotation = .landscapeRight
            self.switchNewOrientation(interfaceOrientation: .landscapeRight)
        }
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        self.configData()                            
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexController.pin.left().top().width(100%).height(100%)
//        self.theControlView.flex.marginLeft(self.view.safeAreaInsets.left);
        self.rootFlexController.flex.layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.fetchUserInfoTrigger.onNext(())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.screenOrientationRotation = .portrait
//            self.switchNewOrientation(interfaceOrientation: .portrait)
//        }
    }
    
    deinit {
        self.theGameVideo.shutdown();
    }
    
    private var sendTcpEventList : [SDTCPCMD] = [SDTCPCMD]();
    
    // MARK: - viewModel

    lazy var bindings: SDGameViewModel.Bindings = {
        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .take(1)
            .asDriverOnErrorJustComplete()
        let viewWillDisappear = rx.sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        return SDGameViewModel.Bindings(
            fetchTrigger: viewDidLoad.asDriver(),
            enterMatchineTrigger: Driver.just(self.machineSn),
            matchineTypeTrigger: Driver.just(self.machineType),
            viewWillDisappearTrigger: viewWillDisappear.asDriver(),
            sendTcpData: sendTcpDataTrigger.asDriverOnErrorJustComplete(),
            closeTrigger: theControlView.theCloseButton.rx.tap.asDriver(),
            fetchUserInfoTrigger: fetchUserInfoTrigger.asDriverOnErrorJustComplete(),
            onRechargeGameMoneyForCoinTrigger: theControlView.theGameMoneyForCoinView.rx.tap.asDriver(),
            onRechargeGameMoneyForPointsTrigger: theControlView.theGameMoneyForPointView.rx.tap.asDriver(),
            gameFuncTrigger: theControlView.theGameFuncListView.gameFuncTrigger.asDriverOnErrorJustComplete()
        )
    }()
    
    var viewModel: Attachable<SDGameViewModel>!
    
    let sendTcpDataTrigger: PublishSubject<SDBaseTcpData> = PublishSubject<SDBaseTcpData>();
    
    let fetchUserInfoTrigger: PublishSubject<Void> = PublishSubject<Void>();
    
    var lastAlertEventType: SDGameAlertEventType? = nil;
    
    func bind(viewModel: SDGameViewModel) -> SDGameViewModel {
        
        viewModel.connectedTimeOutTrigger.asObservable().subscribe(onError: { error in
            log.debug("[connectedTimeOutTrigger] ---> 链接超时 \(error)");
        }).disposed(by: disposeBag);
        
        
        viewModel.enterMatchineReponse.asObservable().filter { data in
            return data != nil
        }.map { data in
            return data!;
        }.asObservable().subscribe(onNext: { data in
            self.theGameVideo.startPlayStream(data.machineSn);
        }).disposed(by: disposeBag);
        
        
        viewModel.sendTcpDataTrigger.asObservable().subscribe(onNext: { [unowned self] data in
            if let cmdEvent = SDTCPCMD.init(rawValue: data.cmd) {
                self.sendTcpEventList.append(cmdEvent);
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.closeTrigger.asObservable().subscribe(onNext: { [unowned self] _ in

            if self.theControlView.gamingStatus == .selfPlaying {
                if let lastTcpEvent = self.sendTcpEventList.last {
                    if lastTcpEvent == .settlement {
                        /// 最后一次操作是 结算
                        self.showExitAlert();
                    } else {
                        self.showExitWithSettlementAlert();
                    }
                } else {
                    self.dismissViewController();
                }
            } else {
                self.dismissViewController();
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.coinValue
            .asObservable()
            .do(afterNext: { [unowned self] value in
                log.debug("[updateCoinValue] ----> \(value)")
                self.theControlView.updateMoneyViewLayout()
            })
            .bind(to: self.theControlView.theGameMoneyForCoinView.rx.moneyValue)
                .disposed(by: self.disposeBag);
        
        viewModel.pointValue
            .asObservable()
            .do(afterNext: { [unowned self] value in
                log.debug("[updateCoinValue] ----> \(value)")
                self.theControlView.updateMoneyViewLayout()
            })
            .bind(to: self.theControlView.theGameMoneyForPointView.rx.moneyValue)
                .disposed(by: self.disposeBag);
        
        
        viewModel.seatPlayerList.asObservable()
            .do(afterNext: { [unowned self] list in
                log.debug("[update seatPlayer list] ----> ")
                self.theControlView.updateCurrentSeatPlayerListView()
                list.forEach { data in
                    if data.isSelf! {
                        self.theControlView.seatPlayIndex = data.position;
                    }
                }
            })
            .bind(to: self.theControlView.theWaitSeatPlayerView.rx.seatPlayers)
                .disposed(by: self.disposeBag);
        
        viewModel.seatPlayerList.asObservable()
            .bind(to: self.theControlView.theAwaitSeatBtView.rx.seatPlayerList)
            .disposed(by: disposeBag);
        
        viewModel.seatPlayerList.asObservable()
            .bind(to: self.theControlView.theSeatPlayerView.rx.seatPlayers)
            .disposed(by: disposeBag);
        
        viewModel.onlookerPlayerList.asObservable().map { playerList -> [String] in
            playerList.map { player in
                player.avatar
            }
        }.do(afterNext: { [unowned self] _ in
            self.theControlView.updateOnlookerPlayerView()
        })
        .bind(to: self.theControlView.theOnlookerPlayerView.rx.avatarList)
            .disposed(by: self.disposeBag);
        
        viewModel.gameStatusTrigger
            .asObservable().do(onNext: { [unowned self] playStatus in
                if playStatus == .selfPlaying {
                    self.fetchUserInfoTrigger.onNext(());
                }
            })
            .bind(to: self.theControlView.rx.gamingStatus)
            .disposed(by: self.disposeBag)
        
        viewModel.gameErrorMessageTrigger.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { message in
                SPIndicator.present(title: message, haptic: .error);
            })
            .disposed(by: disposeBag);
        
        viewModel.receviceTcpSettlementPointResult.asObservable().observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] points in
                ProgressHUD.dismiss();
                NSObject.cancelPreviousPerformRequests(withTarget: self);
                if self.lastAlertEventType == .alertForExitAndSettlement {
                    self.showSettlementResultAlert(alertType: .alertForSettlementResultAndExit, points: points);
                } else if self.lastAlertEventType == .alertForSettlement {
                    self.showSettlementResultAlert(alertType: .alertForSettlementResult, points: points);
                }
            }).disposed(by: disposeBag);
        viewModel.gameUserInfo.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: {
            [unowned self] user in
            self.theControlView.theAvatarView.sd_setImage(with: URL(string: user.avatar));
        }).disposed(by: disposeBag);
        return viewModel
    }
    typealias ViewModel = SDGameViewModel
    let disposeBag = DisposeBag()
}

private extension SDArcadeGameViewController {
    func configView() {
        self.view.backgroundColor = UIColor.black;
        self.view.addSubview(self.rootFlexController)
        self.rootFlexController.flex.define { [unowned self] flex in
            flex.addItem(self.theGameVideo).position(.absolute).width(100%).height(100%).right(0).top(0);
            flex.addItem(self.theControlView).grow(1).height(100%)
        }
    }
    func configData() {
        /// 发送 开始游戏
        self.theControlView.theAwaitSeatBtView.onTapSeatPlay.asObserver().subscribe(onNext: { [unowned self] seatPlayerIndex in
            
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getTcpOperate(postion: seatPlayerIndex))
        }).disposed(by: self.disposeBag)
        
        /// 发送 控制方向
        self.theControlView.theGameDirctionView.touchDirctionTrigger.asObserver().subscribe(onNext: { [unowned self] touchDirction in
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintMoveDirction(dirction: touchDirction, postion: self
                .theControlView.seatPlayIndex));
        }).disposed(by: self.disposeBag);
        
        /// 发送 投币
        self.theControlView.theGameActionView.touchPushCoinTrigger.asObserver().subscribe(onNext: { [unowned self] count in
            var isNewGame = false;
            if let sendEvent = self.sendTcpEventList.last {
                if sendEvent == SDTCPCMD.settlement {
                    isNewGame = true;
                }
            }
//            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintCoin(isNewGame: isNewGame, postion: self.theControlView.seatPlayIndex));
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSeatCoin(isNewGame: isNewGame, postion: self.theControlView.seatPlayIndex, count: count));
        }).disposed(by: disposeBag);
        /// 发送 简单发炮
        self.theControlView.theGameActionView.touchFireTrigger.asObserver().subscribe(onNext: { [unowned self] _ in
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintSingleFire(postion: self.theControlView.seatPlayIndex));
        }).disposed(by: disposeBag);
        /// 发送 开始发炮
        self.theControlView.theGameActionView.touchFireBeganTrigger.asObserver().subscribe(onNext: { [unowned self] _ in
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintStartFire(postion: self.theControlView.seatPlayIndex));
        }).disposed(by: disposeBag);
        /// 发送 结束发炮
        self.theControlView.theGameActionView.touchFireEndTrigger.asObserver().subscribe(onNext: { [unowned self] _ in
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintEndFire(postion: self.theControlView.seatPlayIndex));
        }).disposed(by: disposeBag);
        /// 发送 加倍
        self.theControlView.theGameActionView.touchDoubleTrigger.asObserver().subscribe(onNext: { [unowned self] _ in
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintFireDouble(postion: self.theControlView.seatPlayIndex));
        }).disposed(by: disposeBag);
        /// 发送结算 指令
        self.theControlView.theSeatPlayerView.onSettlementSeatPress.asObserver().subscribe(onNext: { [unowned self] _ in
//            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintSettlement(postion: self.theControlView.seatPlayIndex));
            self.showSettlementAlert();
        }).disposed(by: disposeBag);
        
        self.theControlView.theGameFuncListView.gameFuncTrigger.filter { tag in
            return tag == .settlement_func;
        }.asObservable().subscribe(onNext: { [unowned self] _ in
            self.showSettlementAlert();
        }).disposed(by: disposeBag);
        
        self.theControlView.theGameFuncListView.gameFuncTrigger.filter { tag in
            return tag == .sound_func;
        }.asObservable().subscribe(onNext: { [unowned self] _ in
            self.theGameVideo.muteSteam(false);
            NotificationCenter.default.post(name: NSNotification.Name("kChangeVoiceKey"), object: nil)
        }).disposed(by: disposeBag);
        
        self.theControlView.theGameFuncListView.gameFuncTrigger.filter { tag in
            return tag == .mute_func;
        }.asObservable().subscribe(onNext: { [unowned self] _ in
            self.theGameVideo.muteSteam(true);
            NotificationCenter.default.post(name: NSNotification.Name("kChangeVoiceKey"), object: nil)
        }).disposed(by: disposeBag);
    }
    
    func showExitWithSettlementAlert() {
        let alert = SDGameAlertViewController.init(eventType: .alertForExitAndSettlement);
        self.definesPresentationContext = true;
        alert.modalPresentationStyle = .overCurrentContext;
        alert.view.backgroundColor = UIColor.init(white: 0, alpha: 0.2);
        self.present(alert, animated: false);
        alert.updateAlert("退出游戏", "退出游戏进行结算～");
        alert.alertDelegate = self;
    }
    func showExitAlert() {
        let alert = SDGameAlertViewController.init(eventType: .alertForExit);
        self.definesPresentationContext = true;
        alert.modalPresentationStyle = .overCurrentContext;
        alert.view.backgroundColor = UIColor.init(white: 0, alpha: 0.2);
        self.present(alert, animated: false);
        alert.updateAlert("退出游戏", "拜拜～");
        alert.alertDelegate = self;
    }
    func showSettlementAlert() {
        let alert = SDGameAlertViewController.init(eventType: .alertForSettlement);
        self.definesPresentationContext = true;
        alert.modalPresentationStyle = .overCurrentContext;
        alert.view.backgroundColor = UIColor.init(white: 0, alpha: 0.2);
        self.present(alert, animated: false);
        alert.updateAlert("申请结算", "将剩余的火药抹零折算成能量");
        alert.alertDelegate = self;
    }
    func showSettlementResultAlert(alertType: SDGameAlertEventType, points: Int) {
        let alert = SDGameAlertViewController.init(eventType: alertType);
        self.definesPresentationContext = true;
        alert.modalPresentationStyle = .overCurrentContext;
        alert.view.backgroundColor = UIColor.init(white: 0, alpha: 0.2);
        self.present(alert, animated: false);
        alert.updateAlert("结算", "结算结果: \(points)");
        alert.alertDelegate = self;
    }
    
    @objc func showSettlementResultErrorAlert() {
        ProgressHUD.dismiss();
        if self.lastAlertEventType == .alertForExitAndSettlement {
            self.showSettlementResultAlert(alertType: .alertForSettlementResultAndExit, points: 0);
        } else if self.lastAlertEventType == .alertForSettlement {
            self.showSettlementResultAlert(alertType: .alertForSettlementResult, points: 0);
        }
    }
    
    func dismissViewController() {
        if self.theControlView.seatPlayIndex > 0 {
           self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintArcadeDown(postion: self.theControlView.seatPlayIndex, isLeave: true));
        } else {
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getLeaveRoom());
        }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.screenOrientationRotation = .portrait
            self.switchNewOrientation(interfaceOrientation: .portrait)
        }
        self.dismiss(animated: false);
    }
    
}

extension SDArcadeGameViewController: SDGameAlertEventDelegate {
    func onSureAlert(alert: SDGameAlertViewController, eventType: SDGameAlertEventType) {
        self.lastAlertEventType = eventType;
        if eventType == .alertForExit || eventType == .alertForSettlementResultAndExit {
            self.dismissViewController();
        } else if eventType == .alertForSettlement || eventType == .alertForExitAndSettlement {
            self.sendTcpDataTrigger.onNext(SDTcpSocketSendDataUtils.getSaintSettlement(postion: self.theControlView.seatPlayIndex));
            ProgressHUD.show();
            self.perform(#selector(showSettlementResultErrorAlert), with: self, afterDelay: 4);
        }
    }
}
