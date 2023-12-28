//
//  SPComplateActionSheetViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/12.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import RxSwift
import RxCocoa

typealias DidSelectedActionBlock = (_ action: String) -> Void;

class SPComplateActionSheetViewController: UIViewController {
    lazy var rootFlexContainer: UIView = {
        let theView = UIView.init();
        return theView;
    }()
    
    let actionSheetList: [String]
    
    var disSelectedBlock : DidSelectedActionBlock?
    
    lazy var theCancelButton: UIButton = {
        let theView = UIButton.init();
        theView.setBackgroundImage(UIImage.init(named: "ico_action_sheet_bg"), for: .normal);
        theView.setTitle("取消", for: .normal);
        theView.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .medium)~;
        return theView;
    }()
    
    init(_ list: [String]) {
        actionSheetList = list;
        super.init(nibName: nil, bundle: nil);
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configData();
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.rootFlexContainer.flex.paddingBottom(self.view.pin.safeArea.bottom).layout()
    }
    
    @objc func onCancelPress(_ sender: UIButton) {
        self.dismiss(animated: true);
    }
    @objc func onTapActionItem(_ sender: UIButton) {
        self.dismiss(animated: true);
        self.disSelectedBlock?((sender.titleLabel?.text)!);
    }
}
private extension SPComplateActionSheetViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        
        self.rootFlexContainer.backgroundColor = UIColor.init(white: 0, alpha: 0.88);

        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem().width(100%).grow(1).direction(.column).justifyContent(.end).alignItems(.center).define { [unowned self] flex in
                
                self.actionSheetList.forEach { item in
                    flex.addItem(self.createActionSheetButton(item)).marginBottom(20~);
                }
                flex.addItem(self.theCancelButton).marginTop(10~);
            }
        }
        self.theCancelButton.addTarget(self, action: #selector(onCancelPress(_:)), for: .touchUpInside);
        
    }
    func configData() {
        
    }
    
    func createActionSheetButton(_ title: String) -> UIButton {
        let theView = UIButton.init();
        theView.setBackgroundImage(UIImage.init(named: "ico_action_sheet_bg"), for: .normal);
        theView.setTitle(title , for: .normal);
        theView.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .medium)~;
        theView.addTarget(self, action: #selector(onTapActionItem(_ :)), for: .touchUpInside);
        return theView;
    }
}
