//
//  SDButton.swift
//  game_wwj
//
//  Created by sander shan on 2023/8/17.
//

import UIKit

class SDButton: UIButton {

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height);
    }

}
