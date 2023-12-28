//
//  SPAuthenticationMineCellModel.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/6.
//

import UIKit

class SPAuthenticationMineCellModel: SPMineCellModel {
    var isAuthentication: Bool = false;
    init() {
        self.isAuthentication = false;
        super.init(.authentication);
    }
}
