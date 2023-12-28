//
//  SPPayWebViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import WebKit
class SDWebViewController: SDPortraitViewController {
    
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
    
    lazy var theWebView: WKWebView = {
        let theView = WKWebView()
        return theView;
    }()
    let url: String
    init(_ url: String) {
        self.url = url;
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: false);
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        if #available(iOS 15.0, *) {
            let bar = UINavigationBarAppearance.init();
//            bar.backgroundEffect = nil;
//            bar.backgroundColor = UIColor.clear;
//            bar.shadowColor = nil;
//            bar.backgroundImage = UIImage(named: "ico_top_bg_img")
            
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.rootFlexContainer.pin.top().left().width(100%).height(100%)
        self.theWebView.flex.marginTop(self.view.pin.safeArea.top);
        self.rootFlexContainer.flex.layout()
        self.rootFlexContainer.backgroundColor = UIColor(hex: 0xFFFF00);
    }
}
private extension SDWebViewController {
    func configView() {
        self.view.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem(self.theBgView).position(.absolute).width(100%).height(100%).top(0);
            flex.addItem(self.theNavigationBarView).position(.absolute).width(100%).top(0);
            flex.addItem(self.theWebView).width(100%).height(100%);
        }
    }
    func configData() {
        extendedLayoutIncludesOpaqueBars = true;
        self.theWebView.navigationDelegate = self;
//        self.theWebView.loadHTMLString(self.payData, baseURL: nil);
        if let requestUrl = URL(string: self.url) {
            log.debug("[request] ---> \(requestUrl.absoluteString)")
            self.theWebView.load(URLRequest(url: requestUrl))
        }
    }
}

extension SDWebViewController: WKNavigationDelegate {
//    decidePolicyForNavigationAction
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        
        let request = navigationAction.request;
        if let url = request.url?.absoluteString {
            if url.hasPrefix("alipay://") {
                UIApplication.shared.open(request.url!, completionHandler: { [weak self] result in
                    if result {
                        guard let self = self else { return }
                        self.navigationController?.popViewController(animated: true);
                    }
                })
            } else if url.hasPrefix("https://itunes.apple.com") {
                UIApplication.shared.open(request.url!, completionHandler: { result in
                    
                })
                self.navigationController?.popViewController(animated: true);
            }
        }
        return .allow;
    }
}

