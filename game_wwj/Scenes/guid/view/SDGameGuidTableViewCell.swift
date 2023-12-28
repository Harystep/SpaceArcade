//
//  SDGameGuidTableViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/23.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize
import SwiftHEXColors
import SDWebImage

protocol SDGameGuidCellDelegate: class {
    func onTapVideo(tableViewCell: SDGameGuidTableViewCell, playView: UIView, playUrl: String);
}

class SDGameGuidTableViewCell: UITableViewCell, SDTableViewCellType {
    
    
    fileprivate let rootFlexController = UIView();
    weak var cellDelegate : SDGameGuidCellDelegate?
    
    var indexPath : IndexPath?
    
    lazy var theTitleLabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.systemFont(ofSize: 30, weight: .medium)~;
        theView.textColor = UIColor.white;
        return theView;
    }()
    
    lazy var theCellBgImageView: UIImageView = {
        let theView = UIImageView.init();
        return theView;
    }()
    
    lazy var thePlayButton: UIButton = {
        let theView = UIButton.init();
        theView.setImage(UIImage.init(named: "ico_play"), for: .normal);
        return theView;
    }()
    
    lazy var thePlayContentView: UIView = {
        let theView = UIView.init();
        return theView;
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexController.pin.width(100%).height(100%).left().top();
        self.rootFlexController.flex.layout();
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.selectionStyle = .none;
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var playUrl: String = "";
    func bind(to viewModel: SDTableViewModel) {
        if let model = viewModel as? SDGameGuidViewModel {
            self.playUrl = model.guidUrl;
            self.theCellBgImageView.sd_setImage(with: URL(string: model.guidThumb));
            self.theTitleLabel.text = model.guidTitle;
            self.theTitleLabel.flex.markDirty();
            self.rootFlexController.flex.layout();
        }
    }
}
private extension SDGameGuidTableViewCell {
    func configView() {
        self.contentView.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.clear;
        self.contentView.addSubview(self.rootFlexController);
        self.rootFlexController.flex.paddingTop(30~).define { [unowned self] flex in
            flex.addItem().backgroundColor(UIColor.init(hex: 0xEEAA29)!).cornerRadius(20~).width(690~).height(506~).alignSelf(.center).define {  [unowned self] flex in
                flex.addItem().width(100%).height(84~).justifyContent(.center).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theTitleLabel);
                }
                flex.addItem(self.thePlayContentView).width(100%).justifyContent(.center).alignItems(.center).grow(1).define { [unowned self] flex in
                    flex.addItem(self.theCellBgImageView).position(.absolute).width(100%).height(100%);
                    flex.addItem().position(.absolute).width(100%).height(100%).justifyContent(.center).alignItems(.center).define { flex in
                        flex.addItem(self.thePlayButton).width(94~).height(94~);
                    }
                }
            }
        }
        self.thePlayButton.addTarget(self, action: #selector(onTapPlay(_:)), for: .touchUpInside);
    }
    @objc func onTapPlay(_ sender: UIControl) {
        self.cellDelegate?.onTapVideo(tableViewCell: self, playView: self.thePlayContentView, playUrl: self.playUrl);
    }
}
