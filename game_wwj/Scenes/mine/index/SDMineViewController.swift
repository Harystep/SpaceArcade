//
//
//  SDMineViewController.swift
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

class SDMineViewController: SDPortraitViewController, ViewModelAttaching {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    lazy var thebgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_home_bg"));
        return theView;
    }()
    
    lazy var theTopBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_mine_top_bg"))
        return theView;
    }()
    lazy var theBackImageView: UIButton = {
        let theView = UIButton()
        theView.setImage(UIImage(named: "ico_white_back"), for: .normal)
        theView.addTarget(self, action: #selector(onBackTapClick), for: .touchUpInside)
        return theView;
    }()
    
    lazy var theMemberInfoView: SPMemberTopInfoView = {
        let theView = SPMemberTopInfoView();
        return theView;
    }()
    
    lazy var theTableView: UITableView = {
        let theView = UITableView.init();
        theView.register(SPMineTableViewCell.self, forCellReuseIdentifier: "SPMineTableViewCell");
        theView.backgroundView = UIView.init();
        theView.backgroundColor = UIColor.clear;
        theView.separatorStyle = .none;
        return theView;
    }()
    @objc func onBackTapClick() {
        self.navigationController?.popViewController(animated: true)
    }
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
        self.navigationController?.navigationBar.backItem?.title = "";
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theTopBgImageView.flex.top(-1048~ + self.view.pin.safeArea.top);
        self.rootFlexContainer.flex.paddingTop(self.view.pin.safeArea.top).layout()
        
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xFF0000);
    }
    
    typealias ViewModel = SDMineViewModel;
    var viewModel: Attachable<SDMineViewModel>!
    let disposeBag = DisposeBag()
    
    let requestFetchTrigger: PublishSubject<Void> = PublishSubject();
    
    let uploadImageFilterTrigger: PublishSubject<UIImage> = PublishSubject();
    private let toLoginTrigger: PublishSubject<Void> = PublishSubject();

    
    lazy var bindings: SDMineViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SDMineViewModel.Bindings(
            fetchTrigger: Driver.merge(requestFetchTrigger.asDriverOnErrorJustComplete(), viewWillAppear.asDriver()),
            didSelectedCellIndexPath: self.theTableView.rx.itemSelected.asDriverOnErrorJustComplete(),
            tapAvatarTrigger: self.theMemberInfoView.tapAvatarTrigger.asDriverOnErrorJustComplete(),
            tapInputNameTrigger: self.theMemberInfoView.tapInputNameTrigger.asDriverOnErrorJustComplete(),
            uploadImageFilterTrigger: self.uploadImageFilterTrigger.asDriverOnErrorJustComplete(),
            toLoginTrigger: self.toLoginTrigger.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SDMineViewModel) -> SDMineViewModel {
        viewModel.mineSettingList.asObservable().bind(to: self.theTableView.rx.items(cellIdentifier: "SPMineTableViewCell", cellType: SPMineTableViewCell.self)) { (row, item, cell) in
            cell.bind(to: item);
        }.disposed(by: disposeBag);
        
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        
        viewModel.currentUser.asObservable().subscribe(onNext: { [weak self] user in
            guard let self = self else { return }
            self.theMemberInfoView.authUserInfo = user;
        }).disposed(by: disposeBag);
        
        viewModel.currentUser.withLatestFrom(viewModel.mineSettingList) { (user, settingList) -> (SDUser, [SPMineCellModel]) in
            return (user, settingList);
        }.asObservable().subscribe(onNext: { [weak self] (arg) in
            let (user, settingList) = arg;
            if let settingCell = settingList.first as? SPAuthenticationMineCellModel {
                settingCell.isAuthentication = user.authStatus == 1;
            }
            self?.theTableView.reloadData();
        }).disposed(by: disposeBag);
        
        
        self.uploadImageFilterTrigger.asObservable().subscribe(onNext: { image in
            viewModel.uploadImage(img: image);
        }).disposed(by: disposeBag);
        
        viewModel.localCurrentUser.asObservable().subscribe(onNext: { [weak self] user in
            guard let self = self else { return }
            self.theMemberInfoView.authUserInfo = user;
        }).disposed(by: disposeBag);
        
        
        
        return viewModel;
    }
}
private extension SDMineViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.thebgImageView).position(.absolute).width(100%).height(120%)
            flex.addItem(self.theTopBgImageView).position(.absolute).width(1130~).height(1448~).left(-350~).top(-1048~);
            flex.addItem(self.theBackImageView).width(44).height(44).marginTop(0).left(0)
            flex.addItem(self.theMemberInfoView).width(100%).height(310~).marginTop(0);
            flex.addItem(self.theTableView).width(100%).marginTop(56~).grow(1);
        }
        
    }
    func configData() {
       
        
        Driver.merge(self.theMemberInfoView.tapAvatarTrigger.asDriverOnErrorJustComplete(), self.theMemberInfoView.tapInputNameTrigger.asDriverOnErrorJustComplete()).asObservable().filter({ _ in
            return SDUserManager.token == nil;
        }).subscribe(onNext: { [unowned self] _ in
            self.toLoginTrigger.onNext(());
        }).disposed(by: disposeBag);
    }
}

extension SDMineViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132~;
    }
}
