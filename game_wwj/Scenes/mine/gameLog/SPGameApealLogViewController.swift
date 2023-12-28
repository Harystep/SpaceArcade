//
//  SPGameApealLogViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import CRRefresh

class SPGameApealLogViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
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
        theView.register(SDGameComplaintTableViewCell.self, forCellReuseIdentifier: "SDGameComplaintTableViewCell")
        theView.backgroundColor = UIColor.clear
        theView.separatorStyle = .none
        theView.contentInsetAdjustmentBehavior = .always;
        return theView
    }()
    private var currentPage: Int = 1

    init() {
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configData();
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.currentPage = 1;
        self.requestLogPage.onNext(self.currentPage);
        self.theTableView.cr.beginHeaderRefresh()
        self.title = "我的申诉";

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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.rootFlexContainer.flex.layout()        
    }
    let requestLogPage : PublishSubject<Int> = PublishSubject<Int>();
    
    private let logList: BehaviorRelay<[SDGameComplaintViewModel]> = BehaviorRelay(value: [])


    typealias ViewModel = SPGameApealLogViewModel;
    var viewModel: Attachable<SPGameApealLogViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SPGameApealLogViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SPGameApealLogViewModel.Bindings(
            requestLogPage: requestLogPage.asDriverOnErrorJustComplete(),
            fetchTrigger: viewWillAppear.asDriver(),
            didSelected: self.theTableView.rx.itemSelected.asDriver(),
            appealList: self.logList.asDriver()
        )
    }();
    func bind(viewModel: SPGameApealLogViewModel) -> SPGameApealLogViewModel {
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        viewModel.gameComplaintList.asObservable().subscribe(onNext: { [unowned self] pageData in
            
            let list = pageData.data.map { data in
                SDGameComplaintViewModel(originData: data)
            }
            if self.currentPage == 1 {
                self.logList.accept(list)
                self.theTableView.cr.endHeaderRefresh();
            } else {
                self.logList.accept(self.logList.value + list)
                self.theTableView.cr.endLoadingMore();
            }
        }).disposed(by: disposeBag)
        return viewModel;
    }
}
private extension SPGameApealLogViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0)
            
            flex.addItem(self.theTableView).width(100%).grow(1).marginTop(0);
            
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);

        }
    }
    func configData() {
        extendedLayoutIncludesOpaqueBars = true
        self.title = "我的申诉";
        
        self.theTableView.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            self?.currentPage = 1
            self?.requestLogPage.onNext(1)
        })
        self.theTableView.cr.addFootRefresh(handler: { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.requestLogPage.onNext(self.currentPage)
        })
        
        self.logList.asObservable().bind(to: self.theTableView.rx.items(cellIdentifier: "SDGameComplaintTableViewCell", cellType: SDGameComplaintTableViewCell.self)) { _, item, cell in
            cell.bind(to: item)
        }.disposed(by: disposeBag)
    }
}

extension SPGameApealLogViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220~;
    }
}
