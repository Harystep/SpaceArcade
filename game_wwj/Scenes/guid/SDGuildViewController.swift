//
//  SDGuildViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/22.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa

import EZPlayer

class SDGuildViewController: SDPortraitViewController, ViewModelAttaching{
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
    
    lazy var theTableView: UITableView = {
        let theView = UITableView();
        theView.register(SDGameGuidTableViewCell.self, forCellReuseIdentifier: "SDGameGuidTableViewCell");
        theView.separatorStyle = .none;
        theView.backgroundView = UIView.init();
        theView.backgroundColor = UIColor.clear;
        return theView;
    }()

    
    init() {
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationController?.navigationBar.backItem?.title = "";
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MediaManager.sharedInstance.releasePlayer();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theTableView.flex.marginTop(self.view.pin.safeArea.top );
        self.rootFlexContainer.flex.layout()
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xC5D2FF);
    }
    let requestLogPage: PublishSubject<Int> = .init()
    private var currentPage: Int = 1
    
    private let gameRoom: BehaviorRelay<[SDGameRoomItemViewModel]> = BehaviorRelay(value: []);
    
    typealias ViewModel = SDGuildViewModel;
    var viewModel: Attachable<SDGuildViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SDGuildViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SDGuildViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver()
        )
    }();
    func bind(viewModel: SDGuildViewModel) -> SDGuildViewModel {
        viewModel.guildList.asObservable().map({ list in
            return list.map { data in
                return SDGameGuidViewModel(originData: data)
            }
        }).asObservable().bind(to: self.theTableView.rx
            .items(cellIdentifier: "SDGameGuidTableViewCell", cellType: SDGameGuidTableViewCell.self)) { [unowned self] row, item, cell in
                cell.bind(to: item)
                cell.cellDelegate = self;
                cell.indexPath = IndexPath(item: row, section: 0)
            }.disposed(by: disposeBag);
        return viewModel;
    }

}
private extension SDGuildViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0);
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);
            flex.addItem(self.theTableView).width(100%).grow(1);

        }
    }
    func configData() {
        self.title = "新手指导";
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        
    }
}
extension SDGuildViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 536~;
    }
}
extension SDGuildViewController: SDGameGuidCellDelegate {
   
    func onTapVideo(tableViewCell: SDGameGuidTableViewCell, playView: UIView, playUrl: String) {
        MediaManager.sharedInstance.playEmbeddedVideo(url: URL(string: playUrl)!, embeddedContentView: playView);
        MediaManager.sharedInstance.player?.indexPath = tableViewCell.indexPath;
        MediaManager.sharedInstance.player?.scrollView = self.theTableView;
        
    }
}
