//
//  SDArcadeOnlookerPlayersView.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/17.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

import RxSwift
import RxCocoa

protocol SDArcadeOnlookerPlayersViewType {
    func displayPlayersView();
}

class SDArcadeOnlookerPlayersView: UIView {
    
    fileprivate let rootFlexController = UIView();
    
    lazy var theFoldingAvatarView: SDFoldingAvatarView = {
        let theView = SDFoldingAvatarView.init();
        return theView;
    }()
    
    lazy var theInfoLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 20)~;
        theView.textColor = UIColor(white: 1, alpha: 1);
        theView.numberOfLines = 2;
        return theView;
    }()
    
    var avatarList: [String] = [] {
        didSet {
            if avatarList.count > 3 {
                self.theFoldingAvatarView.avatarList = Array(avatarList.prefix(3));
            } else {
                self.theFoldingAvatarView.avatarList = avatarList;
            }
            self.theInfoLabel.text = "\(avatarList.count)人围观";
        }
    }
    
    init() {
        super.init(frame: CGRectZero);
        self.configView();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.configView();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.left().top().height(100%)
        self.rootFlexController.flex.layout(mode: .adjustWidth);
        self.rootFlexController.layer.masksToBounds = true;
        self.rootFlexController.layer.cornerRadius = self.frame.size.height / 2.0;
        self.rootFlexController.backgroundColor = UIColor(white: 0, alpha: 0.2);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SDArcadeOnlookerPlayersView {
    func configView() {
        self.addSubview(self.rootFlexController);
        self.rootFlexController.flex.direction(.column).alignItems(.center).paddingLeft(10~).paddingRight(15~).define { [unowned self] flex in
            flex.addItem(self.theFoldingAvatarView).height(52~);
            flex.addItem(self.theInfoLabel).marginLeft(10~)
        }
    }
}

extension SDArcadeOnlookerPlayersView: SDArcadeOnlookerPlayersViewType {
    func displayPlayersView() {
        self.theFoldingAvatarView.flex.markDirty();
        self.theInfoLabel.flex.markDirty();
        setNeedsLayout();
    }

}

extension Reactive where Base: SDArcadeOnlookerPlayersView {
    
    /// Bindable sink for `text` property.
    internal var avatarList: Binder< [String]> {
        return Binder(self.base) { view, list in
            view.avatarList = list;
        }
    }
}
