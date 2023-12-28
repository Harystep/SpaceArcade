//
//  SDRechargeViewController.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/27.
//

import UIKit
import PinLayout
import FlexLayout
import SwiftHEXColors
import SwiftyFitsize
import UIKit

import RxCocoa
import RxSwift

import SPIndicator

class SDRechargeViewController: UIViewController {
    // MARK: - UI
//    fileprivate let rootFlexController = UIView()
//
//    lazy var theCollectionView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout();
//        flowLayout.itemSize = CGSize.init(width: 216, height: 300)~;
//        let theView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout);
//        theView.register(SDRechargeUnitCollectionViewCell.self, forCellWithReuseIdentifier: "SDRechargeUnitCollectionViewCell");
//        theView.backgroundColor = UIColor.clear;
//        theView.contentInset = UIEdgeInsets.init(top: 20~, left: 30~, bottom: 0, right: 30~);
//        return theView;
//    }()
//
//    // MARK: - 生命周期
//    init(_ type: SDRechargeType) {
//        self.chargeType = type
//        super.init(nibName: nil, bundle: nil)
//        self.configView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.white;
//        self.configData();
//        // Do any additional setup after loading the view.
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated);
//        self.navigationController?.navigationBar.tintColor = UIColor.black;
//
//        if #available(iOS 15.0, *) {
//            let bar = UINavigationBarAppearance.init();
//            bar.backgroundEffect = nil;
//            bar.backgroundColor = UIColor.white;
//            bar.shadowColor = nil;
//            bar.titleTextAttributes = [.foregroundColor: UIColor.black];
//            self.navigationController?.navigationBar.scrollEdgeAppearance = bar;
//            self.navigationController?.navigationBar.standardAppearance = bar;
//        } else {
//            self.navigationController?.navigationBar.backgroundColor = UIColor.white;
//        }
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated);
//        self.navigationController?.navigationBar.backItem?.title = "";
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews();
//        self.rootFlexController.pin.left().top().width(100%).height(100%);
//        self.rootFlexController.flex.paddingTop(self.view.safeAreaInsets.top).layout();
//    }
//    // MARK: - data
//    let chargeType: SDRechargeType
//    private var chargeList: [SDCollectionViewModel] = [SDCollectionViewModel]();
//
//    let fetchUserInfoTrigger: PublishSubject<Void> = PublishSubject<Void>();
//
//    private let didSelectedChargeItemTrigger: PublishSubject<SDChargeUnitData> = PublishSubject<SDChargeUnitData>();
//
//    let disposeBag = DisposeBag()
//
//    // MARK: - ViewModel
////    lazy var bindings: SDRechargeInGameAlertViewModel.Bindings = {
////        let viewDidLoad = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
////            .mapToVoid()
////            .take(1)
////            .asDriverOnErrorJustComplete()
////        return SDRechargeInGameAlertViewModel.Bindings(fetchTrigger: viewDidLoad.asDriver(), rechargeTypeTrigger: Driver.just(chargeType.rawValue), fetchUserInfoTrigger: fetchUserInfoTrigger.asDriverOnErrorJustComplete(), didSelectedChargeItemTrigger: didSelectedChargeItemTrigger.asDriverOnErrorJustComplete()
////        )
////    }()
//
//    var viewModel: Attachable<SDRechargeInGameAlertViewModel>!
//
//    func bind(viewModel: SDRechargeInGameAlertViewModel) -> SDRechargeInGameAlertViewModel {
//        viewModel.rechargeList.asObservable().subscribe(onNext: { [unowned self] list in
//            self.chargeList.removeAll();
////            self.chargeList.append(contentsOf: list.map({ data in
//////                return SDRechargeUnitCollectionData(originData: data);
////            }));
//
//            self.theCollectionView.reloadData();
//        }).disposed(by: disposeBag);
//
//        viewModel.chargePayResult.asObservable().subscribe(onNext: { response in
//            if response {
//                SPIndicator.present(title: "支付成功", haptic: .success);
//            } else {
//                SPIndicator.present(title: "支付失败", haptic: .error);
//            }
//        }).disposed(by: disposeBag);
//
//        return viewModel;
//    }
//
//    typealias ViewModel = SDRechargeInGameAlertViewModel
//
//}
//
//private extension SDRechargeViewController {
//    func configView() {
//        self.view.backgroundColor = UIColor(hex: 0xF2F2F7);
//        self.view.addSubview(self.rootFlexController);
//        self.rootFlexController.flex.define { [unowned self] flex in
//            flex.addItem(self.theCollectionView).width(100%).grow(1);
//        }
//    }
//    func configData() {
//        self.title = "充值";
//        self.theCollectionView.dataSource = self;
//        self.theCollectionView.delegate = self;
//    }
//}
//extension SDRechargeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.chargeList.count;
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let model = self.chargeList[indexPath.row];
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.getCellIdentifier(), for: indexPath) as! SDCollectionItemType
//        cell.bind(to: model);
//        return cell;
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = self.chargeList[indexPath.row];
//        if let chargeModel = model as? SDRechargeUnitCollectionData {
//            self.didSelectedChargeItemTrigger.onNext(chargeModel.originData);
//        }
//    }
}
