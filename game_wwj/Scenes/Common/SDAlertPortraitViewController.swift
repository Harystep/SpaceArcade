//
//  SDAlertPortraitViewController.swift
//  game_wwj
//
//  Created by sander shan on 2023/6/13.
//

import UIKit

class SDAlertPortraitViewController: SDPortraitViewController {
    func addDismissHandler(_ view: UIView) {
        view.tag = 1032;
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapDissmissAlert));
        tap.delegate = self;
        view.addGestureRecognizer(tap);
    }
    @objc func onTapDissmissAlert() {
        self.dismiss(animated: false);
    }
}

extension SDAlertPortraitViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view {
            if touchView.tag == 1032 {
                return true;
            }
        }
        
        return false;
    }
}
