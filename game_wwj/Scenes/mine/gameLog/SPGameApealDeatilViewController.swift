//
//  SPGameApealDeatilViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa
import CRRefresh

class SPGameApealDeatilViewController: SDPortraitViewController, ViewModelAttaching {
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
    
    lazy var theHeaderView: SDGameDetailHeaderView = {
        let theView = SDGameDetailHeaderView(SDGameLogItemModel.init(self.appealLogItem));
        return theView;
    }()
    
    lazy var theReasonBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_action_sheet_bg"))
        return theView;
    }()
    lazy var theReasonLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var theResultSectionHeaderLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 36)~;
        theView.textColor = UIColor.white;
        theView.text = "申诉结果";
        return theView;
    }()
    lazy var theResultBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_action_sheet_bg"))
        return theView;
    }()
    lazy var theResultLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    
    let appealLogItem: SDAppealDollItemData
    init(_ item: SDAppealDollItemData) {
        self.appealLogItem = item;
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
        self.theHeaderView.flex.marginTop(self.view.pin.safeArea.top );
        self.rootFlexContainer.flex.layout()
        self.view.backgroundColor = UIColor.white;
    }
    
    typealias ViewModel = SPGameApealDeatilViewModel;
    var viewModel: Attachable<SPGameApealDeatilViewModel>!
    let disposeBag = DisposeBag()
    lazy var bindings: SPGameApealDeatilViewModel.Bindings = {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return SPGameApealDeatilViewModel.Bindings(
            fetchTrigger: viewWillAppear.asDriver(),
            dollAppealIdTrigger: Driver.just("\(appealLogItem.id)")
        )
    }();
    func bind(viewModel: SPGameApealDeatilViewModel) -> SPGameApealDeatilViewModel {
        viewModel.appealResult.asObservable().subscribe(onNext: { [unowned self] data in
            if let appealReason = data.appeal {
                self.theReasonLabel.text = appealReason.reason;
                self.theReasonLabel.flex.markDirty();
                
                if appealReason.status == 0 {
                    self.theResultLabel.text = "申诉中"
                    self.theResultLabel.textColor = UIColor(hex: 0xF95556);

                } else if appealReason.status == 1 {
                    self.theResultLabel.text = "申诉通过"
                    self.theResultLabel.textColor = UIColor(hex: 0x68E98A);

                } else if appealReason.status == 2 {
                    self.theResultLabel.text = "申诉拒绝"
                    self.theResultLabel.textColor = UIColor(hex: 0xE96868);
                } else {
                    self.theResultLabel.text = "";
                }
                self.theResultLabel.flex.markDirty();
                self.rootFlexContainer.flex.layout();

            }
        }).disposed(by: disposeBag);
        return viewModel;
    }
}
private extension SPGameApealDeatilViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0)
            flex.addItem().direction(.column).width(100%).alignItems(.center).grow(1).define { [unowned self] flex in
                flex.addItem(self.theHeaderView).height(368~).width(100%);
                flex.addItem().width(690~).height(110~).direction(.row).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theReasonBgImageView).position(.absolute).width(100%).height(100%);
                    flex.addItem(self.theReasonLabel).marginBottom(10~).marginLeft(20~);
                }
                flex.addItem().width(100%).define { [unowned self] flex in
                    flex.addItem(self.theResultSectionHeaderLabel).marginLeft(30~).marginTop(40~);
                }
                
                flex.addItem().width(690~).height(110~).marginTop(20~).direction(.row).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theResultBgImageView).position(.absolute).width(100%).height(100%);
                    flex.addItem(self.theResultLabel).marginBottom(10~).marginLeft(20~);
                }
            }
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);

        }
    }
    func configData() {
        self.title = "申诉详情";
        self.theHeaderView.sectionTitle = "申诉理由";
    }
}
