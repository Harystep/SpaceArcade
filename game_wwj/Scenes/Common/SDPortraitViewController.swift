//
//  SDPortraitViewController.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/22.
//

import UIKit

class SDPortraitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem.init(image: nil, style: .done, target: self, action: #selector(onBackTap));
        self.navigationItem.backBarButtonItem = backItem;
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationController?.navigationBar.backItem?.title = "";
    }
    override var shouldAutorotate: Bool {
        get {
            return false;
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait;
        }
    }
    @objc func onBackTap() {
        
    }
}
