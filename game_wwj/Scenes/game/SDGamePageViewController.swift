//
//  SDGamePageViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/18.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import CRRefresh

enum SDGamePageForType {
    case wwjGame
    case pushGoldGame
    case seatGame
}

class SDGamePageViewController: SDPortraitViewController, ViewModelAttaching{
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    lazy var theBgView: SDNormalBgView = {
        let theView = SDNormalBgView();
        return theView;
    }()
    lazy var theNavigationBarView: SDNormalNavgationBarView = {
        let theView = SDNormalNavgationBarView()
        return theView;
    }()
    
    lazy var theCollectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 330, height: 444)~;
        let theView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        theView.register(SDGameRoomItemCollectionViewCell.self, forCellWithReuseIdentifier: "SDGameRoomItemCollectionViewCell")
        theView.backgroundColor = UIColor.clear;
        theView.backgroundView = UIView.init();
        return theView;
    }()
    
    let groupId: Int;
    init(_ group: Int) {
        self.groupId = group;
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationController?.navigationBar.backItem?.title = "";
        self.currentPage = 1;
        self.requestLogPage.onNext(self.currentPage);
        self.theCollectionView.cr.beginHeaderRefresh()

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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configData();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theCollectionView.flex.marginTop(self.view.pin.safeArea.top + 30~);
        self.rootFlexContainer.flex.layout()
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xC5D2FF);
    }
    let requestLogPage: PublishSubject<Int> = .init()
    private var currentPage: Int = 1
    
    private let gameRoom: BehaviorRelay<[SDGameRoomItemViewModel]> = BehaviorRelay(value: []);
    
    typealias ViewModel = SDGamePageViewModel;
    var viewModel: Attachable<SDGamePageViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDGamePageViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let didSelectedItem = self.theCollectionView.rx.itemSelected.withLatestFrom(self.gameRoom) {
            (indexPath, list) -> (Int, [SDGameRoomItemViewModel]) in
            return (indexPath.row, list);
        }.map { (arg) -> SDGameRoomItemViewModel in
            let (index, list) = arg;
            return list[index];
        }
        return SDGamePageViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            homeGroupId: Driver.just(self.groupId),
            requestLogPage: self.requestLogPage.asDriverOnErrorJustComplete(),
            didSelectedItem: didSelectedItem.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SDGamePageViewModel) -> SDGamePageViewModel {
        viewModel.homeResponse.asObservable().subscribe(onNext: { pageData in
            let list = pageData.data.map { data in
                return SDGameRoomItemViewModel(data);
            }
            if self.currentPage == 1 {
                self.gameRoom.accept(list);
                self.theCollectionView.cr.endHeaderRefresh();
            }else {
                self.gameRoom.accept(self.gameRoom.value + list);
                self.theCollectionView.cr.endLoadingMore();
            }
            
        }).disposed(by: disposeBag);
        return viewModel;
    }

}
private extension SDGamePageViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0);
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);
            flex.addItem(self.theCollectionView).marginLeft(30~).marginRight(30~).marginTop(30~).grow(1);
        }
    }
    func configData() {
        self.title = "游戏列表";
        self.gameRoom.asObservable().bind(to: self.theCollectionView.rx
            .items(cellIdentifier: "SDGameRoomItemCollectionViewCell", cellType: SDGameRoomItemCollectionViewCell.self)) { _, item, cell in
                cell.bind(to: item)
            }.disposed(by: disposeBag);
        
        
        self.theCollectionView.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            self?.currentPage = 1
            self?.requestLogPage.onNext(1)
        })
        self.theCollectionView.cr.addFootRefresh(handler: { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            self.requestLogPage.onNext(self.currentPage)
        })
    }
}
