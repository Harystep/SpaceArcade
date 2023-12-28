//
//  SDGameLogViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/6.
//

import CRRefresh
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import SwiftyFitsize
import UIKit


enum SDGameLogType : Int {
    case logForSeat = 2
    case logForWWj = 1
}

class SDGameLogViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView()
        return theView
    }()

    lazy var theBgView: SDNormalBgView = {
        let theView = SDNormalBgView()
        return theView
    }()
    lazy var theNavigationBarView: SDNormalNavgationBarView = {
        let theView = SDNormalNavgationBarView()
        return theView;
    }()
    lazy var theTableView: UITableView = {
        let theView = UITableView()
        theView.register(SDGameLogItemTableViewCell.self, forCellReuseIdentifier: "SDGameLogItemTableViewCell")
        theView.backgroundColor = UIColor.clear
        theView.separatorStyle = .none
        theView.contentInsetAdjustmentBehavior = .always;
        return theView
    }()
    
    private var currentPage: Int = 1
    
    let requestLogPage: PublishSubject<Int> = .init()

    private let logList: BehaviorRelay<[SDGameLogItemModel]> = BehaviorRelay(value: [])
    
    let gameType: SDGameLogType;
    
    init(_ type: SDGameLogType) {
        gameType = type;
        super.init(nibName: nil, bundle: nil)
        self.configView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if #available(iOS 15.0, *) {
            let bar = UINavigationBarAppearance()
            bar.configureWithTransparentBackground()
            bar.backgroundColor = UIColor.clear
            bar.backgroundEffect = nil

            bar.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.scrollEdgeAppearance = bar
            self.navigationController?.navigationBar.standardAppearance = bar
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
//            self.navigationController?.navigationBar.sets
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.currentPage = 1
        self.requestLogPage.onNext(1)
        self.theTableView.cr.beginHeaderRefresh()
        if self.gameType == .logForSeat {
            self.title = "游戏记录"

        } else if self.gameType == .logForWWj {
            self.title = "抓取记录"

        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theTableView.flex.marginTop(self.view.pin.safeArea.top);
        self.rootFlexContainer.flex.layout()
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xFFFF00)
    }
    
    typealias ViewModel = SDGameLogViewModel
    var viewModel: Attachable<SDGameLogViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDGameLogViewModel.Bindings = { [self] in
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SDGameLogViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            requestLogPage: self.requestLogPage.asDriverOnErrorJustComplete(),
            didSelected: self.theTableView.rx.itemSelected.asDriverOnErrorJustComplete(),
            logList: self.logList.asDriver(),
            gameType: Driver.just(self.gameType.rawValue)
        )
    }()

    func bind(viewModel: SDGameLogViewModel) -> SDGameLogViewModel {
        viewModel.dollLogPageList.asObservable().subscribe(onNext: { [unowned self] pageData in
            
            let list = pageData.data.map { data in
                SDGameLogItemModel(originData: data)
            }
            if pageData.page == 1 {
                self.logList.accept(list)
                self.theTableView.cr.endHeaderRefresh();
            } else {
                self.logList.accept(self.logList.value + list)
                self.theTableView.cr.endLoadingMore();
            }
        }).disposed(by: disposeBag)
        
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        return viewModel
    }
    
    deinit {
        log.debug("[deInit --> \(self)]")
        theTableView.cr.removeHeader()
        theTableView.cr.removeFooter()
    }
}

private extension SDGameLogViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer)
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0)
            
            flex.addItem(self.theTableView).width(100%).grow(1).marginTop(0);
            
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);

        }
    }

    func configData() {
        if self.gameType == .logForSeat {
            self.title = "游戏记录"

        } else if self.gameType == .logForWWj {
            self.title = "抓取记录"

        }
        extendedLayoutIncludesOpaqueBars = true
        
//        self.theTableView.ex
        
        self.theTableView.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            self?.currentPage = 1
            self?.requestLogPage.onNext(1)
        })
        self.theTableView.cr.addFootRefresh(handler: { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.requestLogPage.onNext(self.currentPage)
        })
        
        self.logList.asObservable().bind(to: self.theTableView.rx.items(cellIdentifier: "SDGameLogItemTableViewCell", cellType: SDGameLogItemTableViewCell.self)) { _, item, cell in
            cell.bind(to: item)
        }.disposed(by: disposeBag)
    }
}
extension SDGameLogViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220~;
    }
}
