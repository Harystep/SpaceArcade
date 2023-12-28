//
//  SDHomeViewController.swift
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

class SDHomeViewController: SDPortraitViewController, ViewModelAttaching {
    
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
//                self.toLoginTrigger.onNext(());
                return;
            }
        }
        return theView;
    }()
    
    lazy var theContentScrollView: UIScrollView = {
        let theView = UIScrollView();
        return theView;
    }()
    
    lazy var theContentView: SDHomeGameContentView = {
        let theView = SDHomeGameContentView();
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theTopBgImageView.flex.top(-1048~ + self.view.pin.safeArea.top);
        self.rootFlexContainer.flex.paddingTop(self.view.safeAreaInsets.top).layout()
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xC5D2FF);
        self.theContentScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.theContentView.frame.size.height);
        log.debug("[contentSize] --> \(self.theContentScrollView.contentSize)")
        log.debug("[contentSize] --> \(self.theContentScrollView.frame)")
        log.debug("[contentSize] --> \(self.rootFlexContainer.frame)")
    }
    
    private let toLoginTrigger: PublishSubject<Void> = PublishSubject();
    
    typealias ViewModel = SDHomeViewModel;
    var viewModel: Attachable<SDHomeViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDHomeViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    
        return SDHomeViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            toLoginTrigger: self.toLoginTrigger.asDriverOnErrorJustComplete(),
            homeGroupTrigger: self.theContentView.homeGroupTrigger.asDriverOnErrorJustComplete(),
            functionGuidTrigger: self.theContentView.functionGuidTrigger.asDriverOnErrorJustComplete()
          
        )
    }();
    func bind(viewModel: SDHomeViewModel) -> SDHomeViewModel {
//        viewModel.currentUser.asObservable().subscribe(onNext: { [unowned self] user in
//            log.debug("[currentUser] --> \(user)")
//            DispatchQueue.main.async { [unowned self] in
//                self.theAuthInfoView.authUserInfo = user;
//            }
//        }).disposed(by: disposeBag);
//        viewModel.bannerList.asObservable().subscribe(onNext: { [unowned self] bannerList in
//            let list = bannerList.map { data in
//                return SDBannerDataModel(data);
//            }
//            self.theContentView.bannerList = list;
//        }).disposed(by: disposeBag);
        viewModel.homeGroupList.asObservable().subscribe(onNext: { [unowned self]  groupList in
            self.theContentView.homeGroupList = groupList;
        }).disposed(by: disposeBag);

        return viewModel;
    }
}
private extension SDHomeViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.thebgImageView).position(.absolute).width(100%).height(100%)
            flex.addItem(self.theTopBgImageView).position(.absolute).width(1130~).height(1308~).left(-350~).top(-1048~);
            flex.addItem(self.theAuthInfoView).height(200~).width(100%).marginTop(30~);
            
            flex.addItem(self.theContentScrollView).width(100%).shrink(1).define { flex in
                flex.addItem(self.theContentView).width(100%);
            }
        }
    }
    func configData() {
        
    }
}
