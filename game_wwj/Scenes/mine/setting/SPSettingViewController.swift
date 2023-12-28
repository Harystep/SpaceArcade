//
//  SPSettingViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/7.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa

class SPSettingViewController: SDPortraitViewController, ViewModelAttaching {
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
        let theView = UITableView.init();
        theView.register(SPMineTableViewCell.self, forCellReuseIdentifier: "SPMineTableViewCell");
        theView.backgroundView = UIView.init();
        theView.backgroundColor = UIColor.clear;
        theView.separatorStyle = .none;
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationController?.navigationBar.backItem?.title = "";
        self.title = "设置";

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theTableView.flex.marginTop(self.view.pin.safeArea.top + 30~);
        self.rootFlexContainer.flex.layout()
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xFFFF00);
    }
    
    typealias ViewModel = SPSettingViewModel;
    var viewModel: Attachable<SPSettingViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SPSettingViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SPSettingViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            didSelectedCellIndexPath: self.theTableView.rx.itemSelected.asDriverOnErrorJustComplete()
        )
    }();
    func bind(viewModel: SPSettingViewModel) -> SPSettingViewModel {
        viewModel.settingList.asObservable().bind(to: self.theTableView.rx.items(cellIdentifier: "SPMineTableViewCell", cellType: SPMineTableViewCell.self)) { (row, item, cell) in
            cell.bind(to: item);
        }.disposed(by: disposeBag);
        self.theTableView.rx.setDelegate(self).disposed(by: disposeBag);
        return viewModel;
    }
}
private extension SPSettingViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0);
            flex.addItem(self.theTableView).width(100%).grow(1);
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);
        }
    }
    func configData() {
        self.title = "设置";
        extendedLayoutIncludesOpaqueBars = true;
    }
}

extension SPSettingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132~;
    }
}
