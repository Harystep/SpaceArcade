//
//  SDRechargeInGameAlertViewController.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import SPIndicator

enum SDRechargeType:Int {
    case rechargeForDiamond = 1
    case rechargeForGold = 2
}

class SDRechargeInGameAlertViewController: UIViewController, ViewModelAttaching {

    // MARK: -  UI
    fileprivate let rootFlexController = UIView()

    lazy var theBgView: UIView = {
        let theView = UIView.init();
//        theView.backgroundColor = UIColor(hex: 0xC5D2FF);
//        theView.layer.masksToBounds = true;
//        theView.layer.cornerRadius = 30~;
        return theView;
    }()

    lazy var theImageBgView: UIImageView = {
        let theView = UIImageView.init(image: UIImage(named: "icon_recharge_bg"));
        return theView;
    }()

    lazy var theDiamondView: SDRechargeAlertMoneyUnitView = {
        let theView = SDRechargeAlertMoneyUnitView(.bankForDiamond, true);
        return theView;
    }()

    lazy var theGoldCoinView: SDRechargeAlertMoneyUnitView = {
        let theView = SDRechargeAlertMoneyUnitView(.bankForGoldCoin, true);
        return theView;
    }()
    lazy var thePointsView: SDRechargeAlertMoneyUnitView = {
        let theView = SDRechargeAlertMoneyUnitView(.bankForPoints, true);
        return theView;
    }()

    lazy var theCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout();
//        flowLayout.itemSize = CGSize.init(width: 216, height: 300)~;
        flowLayout.itemSize = CGSize.init(width: 360, height: 482)~;
        flowLayout.scrollDirection = .horizontal
        let theView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout);
        theView.register(SDRechargeUnitCollectionViewCell.self, forCellWithReuseIdentifier: "SDRechargeUnitCollectionViewCell");
        theView.register(SPRechargeItemCollectionViewCell.self, forCellWithReuseIdentifier: "SPRechargeItemCollectionViewCell");
        theView.register(SPRechargeItemForCardCollectionViewCell.self, forCellWithReuseIdentifier: "SPRechargeItemForCardCollectionViewCell");
        theView.backgroundColor = UIColor.clear;
        theView.showsHorizontalScrollIndicator = false
        theView.contentInset = UIEdgeInsets.init(top: 0, left: 30~, bottom: 0, right: 30~);
        return theView;
    }()

    lazy var theColseButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage(named: "ico_white_close")?.withRenderingMode(.alwaysTemplate), for: .normal);
        theView.imageView?.tintColor = UIColor.white;
        return theView;
    }()


    // MARK: - 生命周期
    init(_ type: SDRechargeType) {
        self.chargeType = type
        super.init(nibName: nil, bundle: nil)
        self.configView()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configData();
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.fetchUserInfoTrigger.onNext(())
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.rootFlexController.pin.left().top().width(100%).height(100%);
        self.rootFlexController.backgroundColor = UIColor.black
        self.rootFlexController.flex.layout();
    }
    override var shouldAutorotate: Bool {
        get {
            return false;
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape;
        }
    }

    // MARK: - data &  ViewModel
    let chargeType: SDRechargeType

//    private var chargeList: [SDCollectionViewModel] = [SDCollectionViewModel]();
    private var chargeList: [SPRechargeSectionData] = [];

    let fetchUserInfoTrigger: PublishSubject<Void> = PublishSubject<Void>();

    private let didSelectedChargeItemTrigger: PublishSubject<(SPRechargeItemViewModel, SPPaySupportType)> = PublishSubject();

    typealias ViewModel = SDRechargeInGameAlertViewModel

    let disposeBag = DisposeBag()

    lazy var bindings: SDRechargeInGameAlertViewModel.Bindings = {
        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .take(1)
            .asDriverOnErrorJustComplete()
        return SDRechargeInGameAlertViewModel.Bindings(
            fetchTrigger: viewDidLoad.asDriver(),
            rechargeTypeTrigger: Driver.just(chargeType.rawValue),
            fetchUserInfoTrigger: fetchUserInfoTrigger.asDriverOnErrorJustComplete(),
            didSelectedChargeItemTrigger: didSelectedChargeItemTrigger.asDriverOnErrorJustComplete()
        )
    }()

    var viewModel: Attachable<SDRechargeInGameAlertViewModel>!

    func bind(viewModel: SDRechargeInGameAlertViewModel) -> SDRechargeInGameAlertViewModel {
        viewModel.rechargeList.asObservable().subscribe(onNext: { [unowned self] list in
            self.chargeList.removeAll();
//            self.chargeList.append(contentsOf: list.map({ data in
//                return SDRechargeUnitCollectionData(originData: data);
//            }));
            self.chargeList.append(contentsOf: list);
            self.theCollectionView.reloadData();
        }).disposed(by: disposeBag);

        viewModel.coinValue.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] value in
            NSLog("coinValue:\(value)")
            self.theGoldCoinView.value = Int(value) ?? 0
        }).disposed(by: disposeBag);

        viewModel.pointValue.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] value in
            NSLog("pointValue:\(value)")
            self.thePointsView.value = Int(value) ?? 0
        }).disposed(by: disposeBag);

        viewModel.moneyValue.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] value in
            NSLog("moneyValue:\(value)")
            self.theDiamondView.value = Int(value) ?? 0
        }).disposed(by: disposeBag);

        viewModel.chargePayResult.asObservable().subscribe(onNext: { response in
            if response {
                SPIndicator.present(title: "支付成功", haptic: .success);
                self.fetchUserInfoTrigger.onNext(());
            } else {
//                SPIndicator.present(title: "支付失败", haptic: .error);
                self.showInputExchangeFail();
            }
        }).disposed(by: disposeBag);
        
        viewModel.chargePayAliPayResult.asObservable().subscribe(onNext: { payData in
//            log.debug("[阿里支付] -> \(payData)");
        }).disposed(by: disposeBag);

        return viewModel
    }
}

private extension SDRechargeInGameAlertViewController {
    func configView() {
        self.view.addSubview(self.rootFlexController)
        self.view.addSubview(self.theBgView)
        self.view.addSubview(self.theImageBgView)
        self.view.addSubview(self.theDiamondView)
        self.view.addSubview(self.theGoldCoinView)
        self.view.addSubview(self.thePointsView)
        self.view.addSubview(self.theCollectionView)
        self.view.addSubview(self.theColseButton)
        self.rootFlexController.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        self.theBgView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        self.theImageBgView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }

        self.theDiamondView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.snp_leadingMargin).offset(20)
            make.top.equalTo(self.view.snp_topMargin).offset(30)
            make.height.equalTo(38)
        }
        self.theGoldCoinView.snp.makeConstraints { make in
            make.leading.equalTo(self.theDiamondView.snp_trailingMargin).offset(8)
            make.top.equalTo(self.view.snp_topMargin).offset(30)
            make.height.equalTo(38)
        }
        self.thePointsView.snp.makeConstraints { make in
            make.leading.equalTo(self.theGoldCoinView.snp_trailingMargin).offset(8)
            make.top.equalTo(self.view.snp_topMargin).offset(30)
            make.height.equalTo(38)
        }

        self.theColseButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.snp_trailingMargin).inset(20)
            make.centerY.equalTo(self.theDiamondView)
            make.width.height.equalTo(50)
        }

        self.theCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view).inset(20);
            make.top.equalTo(self.theDiamondView.snp_bottomMargin).offset((40));
            make.bottom.equalTo(self.view.snp_bottomMargin).inset(20);
        }

//        self.rootFlexController.flex.justifyContent(.center).alignItems(.center).define { [unowned self] flex in
//            flex.addItem().define { flex in
//                flex.addItem(self.theBgView).width(750~).height(580~);
//                flex.addItem(self.theImageBgView).width(750~).height(436~).position(.absolute).top(-13~);
//                flex.addItem().width(750~).height(580~).position(.absolute).direction(.column).alignItems(.center).define { [unowned self] flex in
//                    flex.addItem().height(100~).width(100%).justifyContent(.center).alignItems(.center).define {[unowned self] flex in
//                        flex.addItem(self.theAlertTitleLabel)
//                    }
//                    flex.addItem().height(60~).width(100%).direction(.row).paddingLeft(30~).alignItems(.center).define { [unowned self] flex in
//                        flex.addItem(self.theRemainingValueLabel);
//                    }
//                    flex.addItem(self.theCollectionView).width(100%).grow(1)
//                }
//                flex.addItem(self.theColseButton).width(100~).height(100~).position(.absolute).top(0).right(0);
//            }
//        };
    }
    func configData() {
        self.theCollectionView.dataSource = self;
        self.theCollectionView.delegate = self;
        self.theColseButton.addTarget(self, action: #selector(onClosePress), for: .touchUpInside);
    }

    @objc func onClosePress() {
        self.dismiss(animated: true);
    }
    func showInputExchangeFail() {
//        let suerAlertViewController = SDSimpleResultAlertViewController("支付失败");
//        suerAlertViewController.modalPresentationStyle = .overCurrentContext;
//        self.navigationController!.definesPresentationContext = true;
//        self.navigationController!.providesPresentationContextTransitionStyle = true;
//        self.navigationController!.present(suerAlertViewController, animated: false);
    }
}
extension SDRechargeInGameAlertViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.chargeList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chargeList[section].list.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let model = self.chargeList[indexPath.row];
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.getCellIdentifier(), for: indexPath) as! SDCollectionItemType
//        cell.bind(to: model);
//        return cell;
        let model = self.chargeList[indexPath.section].list[indexPath.row];
//        if model.chargeType == .chargeForWeek || model.chargeType == .chargeForMonth {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPRechargeItemForCardCollectionViewCell", for: indexPath) as! SPRechargeItemForCardCollectionViewCell
//            cell.bind(to: model);
//            return cell;
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPRechargeItemCollectionViewCell", for: indexPath) as! SPRechargeItemCollectionViewCell;
//            cell.bind(to: model);
//            return cell;
//
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SDRechargeUnitCollectionViewCell", for: indexPath) as! SDRechargeUnitCollectionViewCell;
        cell.bind(to: model);
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.chargeList[indexPath.section].list[indexPath.row];
        if let chargeModel = model as? SPRechargeItemViewModel {
            let payMethod = chargeModel.paySupportList.first!;
            self.didSelectedChargeItemTrigger.onNext((chargeModel, payMethod));
        }
    }
}
