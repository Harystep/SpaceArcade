//
//  SDExchangeInGameAlertViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/7/20.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import SwiftyFitsize

class SDExchangeInGameAlertViewController: UIViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView()
        return theView
    }()

    lazy var thebgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "icon_recharge_bg"))
        return theView
    }()
    
    lazy var theTopBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_top_bg_img"))
        return theView
    }()
    
    lazy var theCloseButton: UIButton = {
        let theView = UIButton();
        theView.setImage(UIImage(named: "ico_white_close"), for: .normal);
        return theView;
    }()
    
    lazy var theBankView: UIView = {
        let theView = UIView()
        return theView
    }()
    
    lazy var theDiamondView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForDiamond, true)
        return theView
    }()

    lazy var theGoldCoinView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForGoldCoin, true)
        return theView
    }()

    lazy var thePointsView: SDBankUnitView = {
        let theView = SDBankUnitView(.bankForPoints, true)
        return theView
    }()
    
    lazy var theCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let theView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        theView.register(SPExchangeGoldWithPointItemCollectionViewCell.self, forCellWithReuseIdentifier: "SPExchangeGoldWithPointItemCollectionViewCell")
        theView.register(SDExchangeGlodSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionElementKindSectionHeader")
        theView.backgroundColor = UIColor.clear;
        theView.backgroundView = UIView.init();
        theView.showsVerticalScrollIndicator = false;
        theView.contentInset = UIEdgeInsets(top: 0, left: 80~, bottom: 0, right: 80~);
        return theView
    }()
    
    let sureExchagneTrigger: PublishSubject<Int> = PublishSubject();
    
    var exchangeList: [SPExchangeGoldWithPointItemViewModel] = [];
    
    var exchangeGoldHeaderView: SDExchangeGlodSectionHeaderView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.configView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configData()
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
        self.theBankView.flex.marginTop(self.view.pin.safeArea.top)
        self.rootFlexContainer.flex.layout()
        
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xFFFF00)
    }
    private let didSelectedExchangeGoldTrigger: PublishSubject<SPExchangeGoldWithPointItemViewModel> = PublishSubject();
    private let refreshUserInfoTrigger: PublishSubject<Void> = PublishSubject();
    typealias ViewModel = SPExchangeViewModel
    var viewModel: Attachable<SPExchangeViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SPExchangeViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        return SPExchangeViewModel.Bindings(
            fetchTrigger: Driver.merge(viewWillAppear.asDriver(), refreshUserInfoTrigger.asDriverOnErrorJustComplete()),
            sureExchagneTrigger: self.sureExchagneTrigger.asDriverOnErrorJustComplete(),
            didSelectedExchangeGoldTrigger: didSelectedExchangeGoldTrigger.asDriverOnErrorJustComplete()
        )
    }()

    func bind(viewModel: SPExchangeViewModel) -> SPExchangeViewModel {
        viewModel.currentUser.asObservable().subscribe(onNext: { [weak self] user in
            guard let self = self else { return }
            if let money = Int(user.money) {
                self.theDiamondView.value = money
            } else {
                self.theDiamondView.value = 0
            }
            self.theGoldCoinView.value = user.goldCoin
            self.thePointsView.value = user.points
        }).disposed(by: disposeBag)
        viewModel.exchangeGoldList.map { dataList -> [SPExchangeGoldWithPointItemViewModel] in
            let list = dataList.map { data in
                SPExchangeGoldWithPointItemViewModel(originData: data)
            }
            return list
        }.asObservable().subscribe(onNext: { [unowned self] list in
            self.exchangeList.removeAll();
            self.exchangeList.append(contentsOf: list)
            self.theCollectionView.reloadData();
        }).disposed(by: disposeBag);
        
        viewModel.exchangeGoldResult.asObservable().subscribe(onNext: { [unowned  self] result in
            self.exchangeGoldHeaderView?.theExchangeGoldView.theInputView.text = "";
            self.refreshUserInfoTrigger.onNext(());
            if (result) {
                self.showExchangeGoldWithPointSucess();
            } else {
                self.showInputExchangeFail();
            }
        }).disposed(by: disposeBag);
        
        viewModel.pmExchangePointResult.asObservable().subscribe(onNext: { [unowned self] result in
            if result {
                self.showExchangeGoldWithPointSucess();
                self.refreshUserInfoTrigger.onNext(());
            } else {
                self.showExchangeGoldWithPointFail();
            }
        }).disposed(by: disposeBag);
        
        self.theCollectionView.rx.setDelegate(self).disposed(by: disposeBag);
        self.theCollectionView.rx.setDataSource(self).disposed(by: disposeBag);
        return viewModel
    }
}

private extension SDExchangeInGameAlertViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer)
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.thebgImageView).position(.absolute).width(100%).height(100%)
//            flex.addItem(self.theTopBgImageView).position(.absolute).width(1130~).height(1308~).left(-350~).top(-1048~)
            
            flex.addItem().marginTop(58~).direction(.column).define { [unowned self] flex in
                flex.addItem(self.theBankView).marginLeft(30~).width(600~).direction(.row).alignItems(.center).define { [unowned self] flex in
                    if AppDefine.needDiamond {
                        flex.addItem(self.theDiamondView).height(62~).grow(1)
                        flex.addItem(self.theGoldCoinView).height(62~).grow(1).marginLeft(24~)
                    } else {
                        flex.addItem(self.theGoldCoinView).height(62~).grow(1)
                    }
                    flex.addItem(self.thePointsView).height(62~).grow(1).marginLeft(24~)
                }
                flex.addItem(self.theCloseButton).width(50~).height(50~).position(.absolute).right(48~);
            }
            flex.addItem(self.theCollectionView).marginLeft(30~).marginRight(30~).marginTop(20~).grow(1)
        }
        self.theCloseButton.addTarget(self, action: #selector(onClosePress(_:)), for: .touchUpInside);
    }

    func configData() {
        self.title = "兑换中心"
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func showExchangeGoldWithPointSucess() {
        let suerAlertViewController = SDExchangeGoldWithPointSuccessViewController()
        suerAlertViewController.modalPresentationStyle = .overCurrentContext;
        self.definesPresentationContext = true;
        self.providesPresentationContextTransitionStyle = true;
        self.present(suerAlertViewController, animated: false);
    }
    
    func showExchangeGoldWithPointFail() {
        let suerAlertViewController = SDExchangeGoldWithPointSuccessViewController()
        suerAlertViewController.modalPresentationStyle = UIModalPresentationStyle(rawValue: 6)!
//            .overCurrentContext;
        suerAlertViewController.resultType(title: "兑换失败")
        self.definesPresentationContext = true;
        self.providesPresentationContextTransitionStyle = true;
        self.present(suerAlertViewController, animated: false);
    }
    
    func showInputExchangeFail() {
        let suerAlertViewController = SDSimpleResultAlertViewController("兑换失败");
        suerAlertViewController.modalPresentationStyle = .overCurrentContext;
        self.navigationController!.definesPresentationContext = true;
        self.navigationController!.providesPresentationContextTransitionStyle = true;
        self.navigationController!.present(suerAlertViewController, animated: false);
    }
    
    @objc func onClosePress(_ sender: UIControl) {
        self.dismiss(animated: false)
    }
}
extension SDExchangeInGameAlertViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exchangeList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.exchangeList[indexPath.row];
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPExchangeGoldWithPointItemCollectionViewCell", for: indexPath) as! SPExchangeGoldWithPointItemCollectionViewCell;
        cell.bind(to: model)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 330, height: 290)~
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if AppDefine.needDiamond {
//            return CGSize(width: 690, height: 512)~
//        }
        return CGSize.zero;
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.exchangeList[indexPath.row];
        if SDUserManager.token == nil {
            self.didSelectedExchangeGoldTrigger.onNext(model);
            return;
        }
        let normalAtrr = [NSAttributedString.Key.font : UIFont.toZhenYan(size: 36)~, NSAttributedString.Key.foregroundColor: UIColor.white];
        let priceAttr = [NSAttributedString.Key.font: UIFont.toZhenYan(size: 36)~, NSAttributedString.Key.foregroundColor: UIColor.init(hex: 0xEEAA29)!];
        var attributedTitle = NSMutableAttributedString(attributedString: NSAttributedString(string: "确认", attributes: normalAtrr));
        attributedTitle.append(NSAttributedString(string: "\(model.originData.points)", attributes: priceAttr));
        attributedTitle.append(NSAttributedString(string: "能量转换", attributes: normalAtrr));
        attributedTitle.append(NSAttributedString(string: "\(model.originData.goldCoin)", attributes: priceAttr));
        attributedTitle.append(NSAttributedString(string: "太空币", attributes: normalAtrr));
        
        let suerAlertViewController = SDExchangeGoldWithPointViewController(attributedTitle.copy() as! NSAttributedString);
        suerAlertViewController.modalPresentationStyle = .overCurrentContext;
        self.definesPresentationContext = true;
        self.providesPresentationContextTransitionStyle = true;
        self.present(suerAlertViewController, animated: false);
        
        suerAlertViewController.sureExchangeFinish = { [weak self]  in
            guard let self = self else { return }
            self.didSelectedExchangeGoldTrigger.onNext(model);
        }
    }
}

extension SDExchangeInGameAlertViewController: SDExchangeGoldDelegate{
    func onSureExchangeGoldByDiamon(_ num: Int) {
        self.sureExchagneTrigger.onNext(num);
    }
}
