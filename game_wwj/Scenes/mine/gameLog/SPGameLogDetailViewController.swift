//
//  SPGameLogDetailViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/10.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa

import SPIndicator


class SPGameLogDetailViewController: SDPortraitViewController, ViewModelAttaching {
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
        theView.register(SPGameSettlementRecordTableViewCell.self, forCellReuseIdentifier: "SPGameSettlementRecordTableViewCell")
        theView.backgroundColor = UIColor.clear
        theView.separatorStyle = .none
        theView.contentInsetAdjustmentBehavior = .always;
        return theView
    }()
    
    
    let logModel: SDDollLogData;
    init(_ model: SDDollLogData) {
        logModel = model;
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
        self.rootFlexContainer.flex.layout()
        self.view.backgroundColor = UIColor.white;
        self.theTableView.tableHeaderView?.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.frame.width, height: 368~));
    }
    private let complaintForSettelementTrigger: PublishSubject<(SDDollLogDetailSettelementData, String)> = PublishSubject<(SDDollLogDetailSettelementData, String)>();

    typealias ViewModel = SPGameLogDetailViewModel;
    var viewModel: Attachable<SPGameLogDetailViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SPGameLogDetailViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SPGameLogDetailViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            dollLogIdTrigger: Driver.just("\(logModel.id)"),
            dollLogInfoTrigger: Driver.just(logModel),
            complaintForSettelementTrigger: complaintForSettelementTrigger.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SPGameLogDetailViewModel) -> SPGameLogDetailViewModel {
        viewModel.dollLogResult.map { result -> [SPGameSettlementRecordViewModel] in
            let list = result.map { data in
                return SPGameSettlementRecordViewModel(originData: data);
            }
            return list;
        }.asObservable().bind(to: self.theTableView.rx.items(cellIdentifier: "SPGameSettlementRecordTableViewCell", cellType: SPGameSettlementRecordTableViewCell.self)) { [unowned self] _, item, cell in
            cell.bind(to: item)
            cell.settelementDelegate = self;
        }.disposed(by: disposeBag)
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        viewModel.complaintForResult.asObservable().subscribe(onNext: { response in
            if response.getCode() == 0 {
                SPIndicator.present(title: "申请成功", haptic: .success);
            } else {
                SPIndicator.present(title: response.getErrMsg(), haptic: .error);
            }
        }).disposed(by: disposeBag);
        
        return viewModel;
    }
}
private extension SPGameLogDetailViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0)
            flex.addItem(self.theTableView).width(100%).grow(1).marginTop(0);
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);
        }
    }
    func configData() {
        self.theTableView.tableHeaderView = SDGameDetailHeaderView(SDGameLogItemModel.init(originData: self.logModel));
        self.title = "游戏记录详情";
    }
}
extension SPGameLogDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 266~;
    }
}

extension SPGameLogDetailViewController: SDDollLogDetailSettelementDelegate {
    func onComplaintForSettelement(_ data: SDDollLogDetailSettelementData) {
        let alertController = SPComplateActionSheetViewController.init(["爆击奖励领取", "操作按键失灵", "结算失败"]);
        alertController.modalPresentationStyle = .overCurrentContext;
        self.definesPresentationContext = true;
        self.providesPresentationContextTransitionStyle = true;
        self.navigationController!.present(alertController, animated: false);
        
        alertController.disSelectedBlock = { (action) in
            log.debug("[alert] ---> \(action)")
            self.complaintForSettelementTrigger.onNext((data, action));

        }
        
    }
}

