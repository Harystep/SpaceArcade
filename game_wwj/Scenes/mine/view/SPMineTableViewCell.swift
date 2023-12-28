//
//  SPMineTableViewCell.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/5.
//

import UIKit
import FlexLayout
import PinLayout
import SwiftyFitsize

class SPMineTableViewCell: UITableViewCell, SDTableViewCellType {
   
    private let rootFlexContainer: UIView = UIView();
    
    lazy var theBgImageView: UIImageView = {
        let theView = UIImageView(image: UIImage.init(named: "ico_cell_bg"));
        return theView;
    }()
    
    lazy var theLogoImageView: UIImageView = {
        let theView = UIImageView();
        return theView;
    }()
    
    lazy var theCellTitlelabel: UILabel = {
        let theView = UILabel.init();
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.textColor = UIColor.init(hex: 0xECE9FF);
        return theView;
    }()
    
    lazy var theRightImageView: UIImageView = {
        let theView = UIImageView(image: UIImage(named: "ico_white_right"));
        return theView;
    }()
    
    lazy var theRightLabel: UILabel = {
        let theView = UILabel.init()
        theView.font = UIFont.boldSystemFont(ofSize: 30)~;
        theView.textColor = UIColor.init(hex: 0xECE9FF);
        return theView;
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.contentView.backgroundColor = UIColor.clear;
        self.backgroundColor = UIColor.clear;
        self.selectionStyle = .none;
        self.configView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.rootFlexContainer.pin.width(100%).height(100%).left().top();
        self.rootFlexContainer.flex.layout();

    }
    func bind(to viewModel: SDTableViewModel) {
        
        if let authModel = viewModel as? SPAuthenticationMineCellModel {
            self.theRightLabel.isHidden = false;
            self.theRightLabel.text = authModel.isAuthentication ? "已认证" : "未认证";
        } else {
            self.theRightLabel.isHidden = true;
        }
        
        guard let model = viewModel as? SPMineCellModel else { return }
        self.theLogoImageView.image = model.getCellLogoImage();
        self.theCellTitlelabel.text = model.getCellTitle();
        self.theRightLabel.flex.markDirty();
        self.theCellTitlelabel.flex.markDirty();
        self.rootFlexContainer.flex.layout();
    }
    
}

private extension SPMineTableViewCell {
    func configView() {
        self.contentView.addSubview(self.rootFlexContainer);
        self.rootFlexContainer.flex.define { [unowned self] flex in
            flex.addItem().width(690~).height(108~).alignItems(.center).paddingBottom(10~).justifyContent(.spaceBetween).direction(.row).alignSelf(.center).define { [unowned self] flex in
                flex.addItem(self.theBgImageView).position(.absolute).width(100%).height(100%);
                flex.addItem().direction(.row).marginLeft(28~).alignItems(.center).define { [unowned self] flex in
                    flex.addItem(self.theLogoImageView).width(68~).height(68~);
                    flex.addItem(self.theCellTitlelabel);
                }
                flex.addItem().direction(.row).alignItems(.center).marginRight(20~).define { [unowned self] flex in
                    flex.addItem(self.theRightLabel);
                    flex.addItem(self.theRightImageView).width(42~).height(42~);
                }
            }
        }
    }
}
