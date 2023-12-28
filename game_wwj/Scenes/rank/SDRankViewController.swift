//
//  SDRankViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/25.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import CRRefresh
import HandyJSON

class SDRankViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    lazy var theBgView: SDNormalBgView = {
        let theView = SDNormalBgView();
        return theView;
    }()
    lazy var theTopBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_rank_bg"))
        return theView;
    }()
    lazy var theContentView: UIView = {
        let theView = UIView.init()
        return theView;
    }()
    
    lazy var theKindButton: UIButton = {
        let theView = UIButton.init()
        theView.setBackgroundImage(UIImage(named: "ico_rank_kind"), for: .normal);
        theView.setBackgroundImage(UIImage(named: "ico_rank_king_selected"), for: .selected);
        return theView;
    }()
    
    lazy var theFortuneButton: UIButton = {
        let theView = UIButton.init()
        theView.setBackgroundImage(UIImage(named: "ico_rank_fortune"), for: .normal);
        theView.setBackgroundImage(UIImage(named: "ico_rank_fortune_selected"), for: .selected);
        return theView;
    }()
    
    lazy var theRankSortView: SDRankSortView = {
        let theView = SDRankSortView.init(.sortKind)
        return theView;
    }()
    
    lazy var theUserRankView: SDRankUserInfoView = {
        let theView = SDRankUserInfoView()
        return theView;
    }()
    
    lazy var theTableView: UITableView = {
        let theView = UITableView.init();
        theView.register(SDRankSortItemTableViewCell.self, forCellReuseIdentifier: "SDRankSortItemTableViewCell");
        theView.backgroundView = UIView.init();
        theView.backgroundColor = UIColor.clear;
        return theView;
    }()
    
    var currentPage: Int = 1;
    
    private let currentRankIndexTrigger: BehaviorSubject<Int> = BehaviorSubject(value: 0);
    
    private let rankList: BehaviorRelay<[SDRankSortItemViewModel]> = BehaviorRelay(value: [])

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
        self.theTopBgImageView.flex.top(-1144~ + self.view.pin.safeArea.top);
        self.theContentView.flex.marginTop(self.view.pin.safeArea.top + 34~);
        self.theTableView.flex.marginBottom(122~ + self.view.pin.safeArea.bottom);
        self.theUserRankView.flex.bottom(self.view.pin.safeArea.bottom)
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
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.requestLogPage.onNext(1);
    }
    typealias ViewModel = SDRankViewModel;
    var viewModel: Attachable<SDRankViewModel>!
    let disposeBag = DisposeBag()
    let requestLogPage: PublishSubject<Int> = .init()
    typealias Dependency = HadHomeService & HadUserManager & HadCustomService
    lazy var bindings: SDRankViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        return SDRankViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            requestLogPage: self.requestLogPage.asDriverOnErrorJustComplete(),
            currentRankIndexTrigger: self.currentRankIndexTrigger.asDriverOnErrorJustComplete()
        )
    }();
    
    func bind(viewModel: SDRankViewModel) -> SDRankViewModel {
        viewModel.rankLogResult.asObservable().subscribe(onNext: { [weak self] pageData in
            guard let self = self else { return }
            guard let rankIndex = try? self.currentRankIndexTrigger.value() else { return }
            let list = pageData.list.map { data in
                return SDRankSortItemViewModel(originData: data, type: rankIndex == 0 ? .sortKind : .sortFortune);
            }
            if self.currentPage == 1 {
                
                let filterList = list.filter { model in
                    return model.originData.rank == 1 || model.originData.rank == 2 || model.originData.rank == 3;
                }
                self.theRankSortView.rankList = filterList
                self.theUserRankView.rankData(viewModel: pageData.my, type: rankIndex)
                let otherFilterList = list.filter { model in
                    return model.originData.rank != 1 && model.originData.rank != 2 && model.originData.rank != 3;
                }
                self.rankList.accept(otherFilterList)
                self.theTableView.reloadData();
            } else {
                self.rankList.accept(self.rankList.value + list)
                self.theTableView.reloadData();
                self.theTableView.cr.endLoadingMore();
            }
        }).disposed(by: disposeBag);
        
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        
        return viewModel;
    }
    deinit {
        log.debug("[deInit --> \(self)]")
        theTableView.cr.removeFooter()
    }
}
private extension SDRankViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0);
            flex.addItem(self.theTopBgImageView).position(.absolute).width(1130~).height(1184~).left(-350~).top(-1162~);
            flex.addItem(self.theContentView).grow(1).direction(.column).define { [unowned self] flex in
                flex.addItem().direction(.row).alignItems(.center).alignSelf(.center).define { [unowned self] flex in
                    flex.addItem(self.theKindButton).width(328~).height(98~);
                    flex.addItem(self.theFortuneButton).width(328~).height(98~).marginLeft(26~);
                }
                flex.addItem(self.theRankSortView).width(100%).height(460~);
                flex.addItem().width(100%).grow(1).direction(.column).define { flex in
                    flex.addItem(self.theTableView).width(100%).marginTop(20~).grow(1).marginBottom(122~)
                    flex.addItem(self.theUserRankView).position(.absolute).width(100%).height(122~).bottom(0).left(0);
                }
            }
        }
    }
    func configData() {
        extendedLayoutIncludesOpaqueBars = true;
        self.title = "排行榜";
        self.currentRankIndexTrigger.asObserver().subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.theKindButton.isSelected = index == 0;
            self.theFortuneButton.isSelected = index == 1;
            self.theRankSortView.rankType = index == 0 ? .sortKind : .sortFortune;
        }).disposed(by: disposeBag);
        self.theKindButton.addTarget(self, action: #selector(onKindPress(_:)), for: .touchUpInside);
        self.theFortuneButton.addTarget(self, action: #selector(onFortunePress(_ :)), for: .touchUpInside);
//        self.theTableView.cr.addFootRefresh(handler: { [weak self] in
//            guard let self = self else { return }
//            if self.currentPage == 2 {
//                self.theTableView.cr.endLoadingMore();
//                return
//            }
//            self.currentPage += 1
//            self.requestLogPage.onNext(self.currentPage)
//        })
        self.rankList.asObservable().bind(to: self.theTableView.rx.items(cellIdentifier: "SDRankSortItemTableViewCell", cellType: SDRankSortItemTableViewCell.self)) { _, item, cell in
            cell.bind(to: item)
        }.disposed(by: disposeBag)
    }
    
    @objc func onKindPress(_ sender: UIButton) {
        self.currentRankIndexTrigger.onNext(0);
        self.currentPage = 1;
        self.requestLogPage.onNext(self.currentPage);
    }
    @objc func onFortunePress(_ sender: UIButton) {
        self.currentRankIndexTrigger.onNext(1);
        self.currentPage = 1;
        self.requestLogPage.onNext(self.currentPage);
    }
}
extension SDRankViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122~;
    }
}
