//
//  SDHomeGameContentView.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/1.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import FSPagerView
import SDWebImage

import RxSwift

class SDHomeGameContentView: UIView {
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theSeatGameBt: UIButton = {
        let theView = UIButton.init()

        return theView;
    }()
    
    lazy var theHomeGropView: UIView = {
        let theView = UIView.init()
        return theView;
    }()
    
    lazy var thePushCoinGamebt: UIButton = {
        let theView = UIButton.init();

        return theView;
    }()
    
    lazy var theWwjGameBt: UIButton = {
        let theView = UIButton.init();

        return theView;
    }()
    
    lazy var theSectionTipLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 36, weight: .bold)~;
        theView.textColor = UIColor.white;
        theView.text = "功能指引";
        return theView;
    }()
    
    lazy var theSectionPostTipLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 36, weight: .bold)~;
        theView.textColor = UIColor.white;
        theView.text = "活动公告";
        return theView;
    }()

    
    lazy var theGuidForNewButton: SDGameFuncGuidButton = {
        let theView = SDGameFuncGuidButton(.GuidForNew);
        return theView;
    }()
    
    lazy var theGuidForInviteButton: SDGameFuncGuidButton = {
        let theView = SDGameFuncGuidButton(.GuidForInvite);
        return theView;
    }()
    lazy var theGuidForSignButton: SDGameFuncGuidButton = {
        let theView = SDGameFuncGuidButton(.GuidForSign);
        return theView;
    }()
    lazy var theGuidForKefuButton : SDGameFuncGuidButton = {
        let theView = SDGameFuncGuidButton(.GuidForKefu);
        return theView;
    }()
    
    lazy var thePostBannerView: FSPagerView = {
        let theView = FSPagerView.init();
        theView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell");
        return theView;
    }()
    
    var bannerList: [SDBannerDataModel] = [SDBannerDataModel]() {
        didSet {
            self.thePostBannerView.reloadData();
        }
    }

    var homeGroupList: [SDHomeGroupItem] = [] {
        didSet {
            if self.homeGroupList.count == 3 {
                let homeGroup1 = self.homeGroupList[0];
                self.theSeatGameBt.tag = 0;
                SDWebImageManager.shared.loadImage(with: URL(string: homeGroup1.thumb), progress: nil) { image, imageData, error, cacheType, isFinish, url in
                    self.theSeatGameBt.setImage(image, for: .normal);
//                    self.theSeatGameBt.addCorner(conrners: .allCorners, radius: 20)
                }
                let homeGroup2 = self.homeGroupList[1];
                self.thePushCoinGamebt.tag = 1;
                SDWebImageManager.shared.loadImage(with: URL(string: homeGroup2.thumb), progress: nil) { image, imageData, error, cacheType, isFinish, url in
                    self.thePushCoinGamebt.setImage(image, for: .normal);
//                    self.thePushCoinGamebt.addCorner(conrners: .allCorners, radius: 20)
                }
                let homeGroup3 = self.homeGroupList[2];
                self.theWwjGameBt.tag = 2;
                SDWebImageManager.shared.loadImage(with: URL(string: homeGroup3.thumb), progress: nil) { image, imageData, error, cacheType, isFinish, url in
                    self.theWwjGameBt.setImage(image, for: .normal);
//                    self.theWwjGameBt.addCorner(conrners: .allCorners, radius: 20)
                }
            }

        }
    }
    
    let homeGroupTrigger: PublishSubject<Int> = PublishSubject();
    
    let functionGuidTrigger: PublishSubject<SDGameGuidType> = PublishSubject();
    
    init() {
        super.init(frame: CGRect.init());
        
//        self.bannerList.append(SDBannerDataModel(UIImage(named: "ico_tmp_1")!));
        self.configView();
        NotificationCenter.default.addObserver(self, selector: #selector(notiReadBackData(_:)), name: NSNotification.Name("kSignKey"), object: nil)
    }
    
    @objc func notiReadBackData(_:Notification) {
        self.functionGuidTrigger.onNext(SDGameGuidType.GuidForSign);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.top().left().width(100%).height(100%);
        self.rootFlexContainer.flex.layout();
    }
}
extension UIView {
    ///添加部分圆角（自动布局情况下，要在布局后使用）
    func addCorner(conrners: UIRectCorner , radius: CGFloat) {
        self.layoutIfNeeded()
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

private extension SDHomeGameContentView {
    func configView() {
        self.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theHomeGropView).direction(.row).marginLeft(26~).marginRight(26~).define
            { [unowned self] flex in
                flex.addItem(self.theSeatGameBt).width(336~).height(638~).marginTop(14~);
                flex.addItem().direction(.column).alignItems(.center).marginLeft(26~).marginTop(14~).define
                { [unowned self] flex in
                    flex.addItem(self.thePushCoinGamebt).width(336~).height(314~);
                    flex.addItem(self.theWwjGameBt).width(336~).height(314~).marginTop(10~)
                }
            }
            flex.addItem(self.theSectionTipLabel).marginLeft(26~).marginTop(38~).marginBottom(20~);
            
            flex.addItem().width(100%).direction(.row).wrap(.wrap).marginLeft(26~).justifyContent(.start).define { [unowned self] flex in
                flex.addItem(self.theGuidForNewButton).width(330~).height(166~).marginBottom(28~);
                flex.addItem(self.theGuidForInviteButton).width(330~).height(166~).marginLeft(30~).marginBottom(28~);
                flex.addItem(self.theGuidForSignButton).width(330~).height(166~);
                flex.addItem(self.theGuidForKefuButton).width(330~).height(166~).marginLeft(30~);
            }
            flex.addItem(self.theSectionPostTipLabel).marginLeft(26~).marginTop(38~).marginBottom(20~);
            
            flex.addItem(self.thePostBannerView).margin(20~, 30~).height(170~);
                        
        }
        self.thePostBannerView.dataSource = self;
        
        self.theSeatGameBt.addTarget(self, action: #selector(onHomeGroupTap(_:)), for: .touchUpInside);
        self.thePushCoinGamebt.addTarget(self, action: #selector(onHomeGroupTap(_:)), for: .touchUpInside);
        self.theWwjGameBt.addTarget(self, action: #selector(onHomeGroupTap(_:)), for: .touchUpInside);
        
        
        self.theGuidForNewButton.addTarget(self, action: #selector(onGameGuidTap(_:)), for: .touchUpInside);
        self.theGuidForKefuButton.addTarget(self, action: #selector(onGameGuidTap(_:)), for: .touchUpInside);
        self.theGuidForSignButton.addTarget(self, action: #selector(onGameGuidTap(_:)), for: .touchUpInside);
        self.theGuidForInviteButton.addTarget(self, action: #selector(onGameGuidTap(_:)), for: .touchUpInside);
                
    }
    
    @objc func onHomeGroupTap(_ sender: UIButton) {
        self.homeGroupTrigger.onNext(sender.tag);
    }
    @objc func onGameGuidTap(_ sender: UIControl) {
        if let guidButton = sender as? SDGameFuncGuidButton {
            self.functionGuidTrigger.onNext(guidButton.guidType);
        }
    }
}
extension SDHomeGameContentView: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.bannerList.count;
    }
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let model = self.bannerList[index];
        cell.imageView?.sd_setImage(with: URL(string: model.originData.imgUrl));
        return cell;
    }
}
