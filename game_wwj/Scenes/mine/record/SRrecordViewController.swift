//
//  SRrecordViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import CRRefresh

class SRrecordViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    lazy var thebgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_home_bg"));
        return theView;
    }()
    
    lazy var theTopBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_recored_bg"))
        return theView;
    }()
    
    lazy var theClassTabView: SPTabView = {
        if AppDefine.needDiamond {
            let theView = game_wwj.SPTabView(["太空币","钻石","能量"]);
            return theView
        }
        let theView = game_wwj.SPTabView(["太空币", "能量"]);
        return theView
    }()
    
    lazy var theLineTabView: SPLineTabView = {
        let theView = SPLineTabView(["支出", "收入"])
        return theView;
    }()
    lazy var theTableView: UITableView = {
        let theView = UITableView()
        theView.register(SPRecordItemTableViewCell.self, forCellReuseIdentifier: "SPRecordItemTableViewCell")
        theView.backgroundColor = UIColor.clear
        theView.separatorStyle = .none
        theView.contentInsetAdjustmentBehavior = .always;
        return theView
    }()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theTopBgImageView.flex.top(-1162~ + self.view.pin.safeArea.top);
        self.theClassTabView.flex.marginTop(self.view.pin.safeArea.top + 18~);
        self.theClassTabView.layer.masksToBounds = true;
        self.theClassTabView.layer.cornerRadius = 42~;
        self.rootFlexContainer.flex.layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        if #available(iOS 15.0, *) {
            let bar = UINavigationBarAppearance.init();

            bar.configureWithTransparentBackground()
            bar.backgroundColor = UIColor.clear;
            bar.backgroundEffect =  nil;
            
            bar.titleTextAttributes = [.foregroundColor: UIColor.white];
            self.navigationController?.navigationBar.scrollEdgeAppearance = bar;
            self.navigationController?.navigationBar.standardAppearance = bar;
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default);
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white];
//            self.navigationController?.navigationBar.sets
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestLogPage.onNext(1);
        theTableView.cr.beginHeaderRefresh()
    }
    private let logList: BehaviorRelay<[SPRecordItemViewModel]> = BehaviorRelay(value: [])
    
    let classTabIndexTrigger: BehaviorSubject<Int> = BehaviorSubject<Int>.init(value: 0)
    let comeTabIndexTrigger: BehaviorSubject<Int> = BehaviorSubject<Int>.init(value: 0);
    let requestLogPage: PublishSubject<Int> = .init()
    private var currentPage: Int = 1

    typealias ViewModel = SRrecordViewModel;
    var viewModel: Attachable<SRrecordViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SRrecordViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SRrecordViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            requestLogPage: self.requestLogPage.asDriverOnErrorJustComplete(),
            classTabIndexTrigger: self.classTabIndexTrigger.asDriverOnErrorJustComplete(),
            comeTabIndexTrigger: self.comeTabIndexTrigger.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SRrecordViewModel) -> SRrecordViewModel {
        
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        
        viewModel.requestLogResult.asObservable().subscribe(onNext: { [weak self] pageData in
            guard let self = self else { return }
            let list = pageData.data.map { data in
                return SPRecordItemViewModel(data);
            }
            if pageData.page == 1 {
                self.logList.accept(list)
                self.theTableView.cr.endHeaderRefresh();
            } else {
                self.logList.accept(self.logList.value + list)
                self.theTableView.cr.endLoadingMore();
            }
        }).disposed(by: disposeBag);
        

        return viewModel;
    }
    deinit {
        log.debug("[deInit --> \(self)]")
        theTableView.cr.removeHeader()
        theTableView.cr.removeFooter()
    }
}
private extension SRrecordViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.thebgImageView).position(.absolute).width(100%).height(100%)
            flex.addItem(self.theTopBgImageView).position(.absolute).width(1130~).height(1314~).left(-350~).top(-1162~);
            flex.addItem(self.theClassTabView).width(690~).height(84~).alignSelf(.center);
            flex.addItem(self.theLineTabView).width(448~).height(142~).alignSelf(.center);
            flex.addItem(self.theTableView).width(100%).grow(1);
        }
    }
    func configData() {
        extendedLayoutIncludesOpaqueBars = true;
        self.title = "消费记录";
        self.theClassTabView.tabDelegate = self;
        self.theLineTabView.tabDelegate = self;
        
        
        self.theTableView.cr.addFootRefresh(handler: { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.requestLogPage.onNext(self.currentPage)
        })
        self.theTableView.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            guard let self = self else { return }
            self.currentPage = 1
            self.requestLogPage.onNext(self.currentPage)
        })
        
        self.logList.asObservable().bind(to: self.theTableView.rx.items(cellIdentifier: "SPRecordItemTableViewCell", cellType: SPRecordItemTableViewCell.self)) { _, item, cell in
            cell.bind(to: item)
        }.disposed(by: disposeBag)
    }
}

extension SRrecordViewController: SPTabViewDelegate, SPLineTabDelegate {
    func SPTabView(tabView: SPTabView, didSelected index: Int) {
        log.debug("[tabView] didSelected \(index)");
        if AppDefine.needDiamond {
            self.classTabIndexTrigger.onNext(index)
        } else {
            self.classTabIndexTrigger.onNext(index == 1 ? 2 : 0);
        }
        self.currentPage = 1;
        self.requestLogPage.onNext(1);
        theTableView.cr.beginHeaderRefresh()
    }
    func SPTabView(tabView: SPLineTabView, didSelected index: Int) {
        log.debug("[SPLineTabView] didSelected \(index)");
        self.comeTabIndexTrigger.onNext(index);
        self.currentPage = 1;
        self.requestLogPage.onNext(1);
        theTableView.cr.beginHeaderRefresh()
    }
}
extension SRrecordViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170~;
    }
}
