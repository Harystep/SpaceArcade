//
//  SDShopViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/5/27.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import SPIndicator


class SDShopViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    lazy var thebgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_home_bg"));
        return theView;
    }()
    
    lazy var theTopBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_top_bg_img"))
        return theView;
    }()
    
    lazy var theAuthInfoView: SDAuthInfoView = {
        let theView = SDAuthInfoView();
        theView.controllBlock = { [weak self] in
            guard let self = self else { return }
            guard let _ = SDUserManager.token else {
                self.toLoginTrigger.onNext(());
                return;
            }
        }
        return theView;
    }()
    lazy var theClassTabView: SPTabView = {
        let theView = game_wwj.SPTabView(["太空币", "钻石"]);
        return theView
    }()
    
    
    lazy var theCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout();
        let theView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout);
        theView.backgroundColor = UIColor.clear;
        theView.backgroundView = UIView.init();
        theView.register(SPRechargeItemCollectionViewCell.self, forCellWithReuseIdentifier: "SPRechargeItemCollectionViewCell");
        theView.register(SPRechargeItemForCardCollectionViewCell.self, forCellWithReuseIdentifier: "SPRechargeItemForCardCollectionViewCell");
        theView.showsVerticalScrollIndicator = false;
        return theView;
    }()
    init() {
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configData();
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        self.chargeTypeTrigger.onNext(try! self.chargeTypeTrigger.value());
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theTopBgImageView.flex.top(-1048~ + self.view.pin.safeArea.top);
        self.rootFlexContainer.flex.paddingTop(self.view.safeAreaInsets.top).layout()
        
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xC5D2FF);
        
        self.theClassTabView.layer.masksToBounds = true;
        self.theClassTabView.layer.cornerRadius = 42~;
    }
    
    private var chargeList: [SPRechargeSectionData] = [];
    
    typealias ViewModel = SDShopViewModel;
    var viewModel: Attachable<SDShopViewModel>!
    let disposeBag = DisposeBag()
    private let chargeTypeTrigger: BehaviorSubject<Int> = BehaviorSubject<Int>.init(value: 2);
    private let didSelectedChargeItemTrigger: PublishSubject<(SPRechargeItemViewModel, SPPaySupportType)> = PublishSubject();
    private let toLoginTrigger: PublishSubject<Void> = PublishSubject();

    lazy var bindings: SDShopViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SDShopViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            chargeTypeTrigger: self.chargeTypeTrigger.asDriverOnErrorJustComplete(),
            didSelectedChargeItemTrigger: self.didSelectedChargeItemTrigger.asDriverOnErrorJustComplete(),
            toLoginTrigger: self.toLoginTrigger.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SDShopViewModel) -> SDShopViewModel {
        viewModel.currentUser.asObservable().subscribe(onNext: { [unowned self] user in
            self.theAuthInfoView.authUserInfo = user;
        }).disposed(by: disposeBag);
        
        viewModel.chargeList.asObservable().subscribe(onNext: {[unowned self]   list in
            self.chargeList.removeAll();
            self.chargeList.append(contentsOf: list);
            self.theCollectionView.reloadData();
        }).disposed(by: disposeBag);
        
        viewModel.chargePayResult.asObservable().subscribe(onNext: { response in
            if response {
                SPIndicator.present(title: "支付成功", haptic: .success);
            } else {
//                SPIndicator.present(title: "支付失败", haptic: .error);
                self.showInputExchangeFail();
                
            }
        }).disposed(by: disposeBag);
        
        viewModel.chargePayAliPayResult.asObservable().subscribe(onNext: { payData in
//            log.debug("[阿里支付] -> \(payData)");
        }).disposed(by: disposeBag);
        
        
        return viewModel;
    }
}
private extension SDShopViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.thebgImageView).position(.absolute).width(100%).height(100%)
            flex.addItem(self.theTopBgImageView).position(.absolute).width(1130~).height(1308~).left(-350~).top(-1048~);
            flex.addItem(self.theAuthInfoView).height(200~).width(100%).marginTop(30~);
            flex.addItem(self.theClassTabView).width(690~).height(84~).alignSelf(.center).marginTop(30~);
            flex.addItem(self.theCollectionView).marginLeft(30~).marginRight(30~).grow(1).marginTop(30~);
        }
    }
    func configData() {
        self.theClassTabView.tabDelegate = self;
        self.theCollectionView.dataSource = self;
        self.theCollectionView.delegate = self;
        NotificationCenter.default.addObserver(self, selector: #selector(toBankTirgger(_:)), name: NSNotification.Name(rawValue: "topBankTrigger"), object: nil);
    }
    func payForChargeItem(_ payMethod: SPPaySupportType, chargeItem: SPRechargeItemViewModel) {
        if payMethod == .aliPay {
            
        } else if payMethod == .applePay {
            
        }
        
        self.didSelectedChargeItemTrigger.onNext((chargeItem, payMethod));

    }
    func showInputExchangeFail() {
        let suerAlertViewController = SDSimpleResultAlertViewController("支付失败");
        suerAlertViewController.modalPresentationStyle = .overCurrentContext;
        self.navigationController!.definesPresentationContext = true;
        self.navigationController!.providesPresentationContextTransitionStyle = true;
        self.navigationController!.present(suerAlertViewController, animated: false);
    }
    @objc func toBankTirgger(_ notification: Notification) {
        let info = notification.userInfo;
        if let type = notification.object as? SDBankType {
            switch type {
            case .bankForDiamond:
                self.theClassTabView.selectedIndex = 1;
                break;
            case .bankForGoldCoin:
                self.theClassTabView.selectedIndex = 0;
                break;
            default:
                break;
            }
            self.chargeTypeTrigger.onNext(self.theClassTabView.selectedIndex == 0 ? 2 : 1);

        }
        
    }
}

extension SDShopViewController: SPTabViewDelegate {
    func SPTabView(tabView: SPTabView, didSelected index: Int) {
        log.debug("[tabView] didSelected \(index)");
        self.chargeTypeTrigger.onNext(index == 0 ? 2 : 1);
    }
}

extension SDShopViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.chargeList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chargeList[section].list.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = self.chargeList[indexPath.section].list[indexPath.row];
        if model.chargeType == .chargeForWeek || model.chargeType == .chargeForMonth {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPRechargeItemForCardCollectionViewCell", for: indexPath) as! SPRechargeItemForCardCollectionViewCell
            cell.bind(to: model);
            return cell;
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPRechargeItemCollectionViewCell", for: indexPath) as! SPRechargeItemCollectionViewCell;
            cell.bind(to: model);
            return cell;
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = self.chargeList[section]
        if section.sectionType == .sectionForCard {
            return CGSize.zero;
        }
        return CGSize(width: 0, height: 24)~;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = self.chargeList[indexPath.section]
        if section.sectionType == .sectionForCard {
            return CGSize.init(width: 750, height: 278)~
        }
        return CGSize.init(width: 330, height: 320)~
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let section = self.chargeList[section]
        if section.sectionType == .sectionForCard {
            return 0;
        }
        return 30~;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let section = self.chargeList[section]
        if section.sectionType == .sectionForCard {
            return 0;
        }
        return 30~;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.chargeList[indexPath.section].list[indexPath.row];
        if model.paySupportList.count >= 1 {
            let payMethod = model.paySupportList.first!;
            self.payForChargeItem(payMethod, chargeItem: model);
        }
    }
}

