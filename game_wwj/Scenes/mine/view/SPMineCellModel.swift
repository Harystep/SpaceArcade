//
//  SPMineCellModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/5.
//

import UIKit


enum SDMineCellType {
    case authentication
    case seatGameLog
    case wawajGameLog
    case myAppeal
    case consumptionRecord
    case invitedShared
    case setting
    case userAgreement
    case privacyAgreement
    case signOut
    case deleteAccount
}

class SPMineCellModel: SDTableViewModel {
    func getCellIdentifier() -> String {
        return "SPMineTableViewCell";
    }
    let cellType: SDMineCellType;
    init(_ type: SDMineCellType) {
        cellType = type;
    }
    func getCellLogoImage() -> UIImage? {
        switch self.cellType {
            
        case .authentication:
            return UIImage(named: "ico_mine_cell_1");
        case .seatGameLog:
            return UIImage(named: "ico_mine_cell_2");
        case .wawajGameLog:
            return UIImage(named: "ico_mine_cell_3");
        case .myAppeal:
            return UIImage(named: "ico_mine_cell_4");
        case .consumptionRecord:
            return UIImage(named: "ico_mine_cell_5");
        case .invitedShared:
            return UIImage(named: "ico_mine_cell_6");
        case .setting:
            return UIImage(named: "ico_mine_cell_7");
        case .userAgreement:
            return UIImage(named: "ico_setting_fun_1")
        case .privacyAgreement:
            return UIImage(named: "ico_setting_fun_2")
        case .signOut:
            return UIImage(named: "ico_setting_fun_4")
        case .deleteAccount:
            return UIImage(named: "ico_setting_fun_3")
        }
    }
    
    func getCellTitle() -> String {
        switch self.cellType {
            
        case .authentication:
            return "实名认证";
        case .seatGameLog:
            return "游戏记录";
        case .wawajGameLog:
            return "抓取记录"
        case .myAppeal:
            return "我的申诉"
        case .consumptionRecord:
            return "消费记录";
        case .invitedShared:
            return "邀请分享"
        case .setting:
            return "设置";
        case .userAgreement:
            return "用户隐私"
        case .privacyAgreement:
            return "隐私协议"
        case .signOut:
            return "退出登录"
        case .deleteAccount:
            return "注销"
        }
    }
}
