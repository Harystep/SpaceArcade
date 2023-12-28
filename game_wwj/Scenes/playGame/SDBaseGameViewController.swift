//
//  SDBaseGameViewController.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

class SDBaseGameViewController: UIViewController {
    let machineSn: String;
    let machineType: Int;
    
    init(machineSn: String, machineType: Int) {
        self.machineSn = machineSn;
        self.machineType = machineType;
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
    }
    
    func switchNewOrientation(interfaceOrientation: UIInterfaceOrientation) {
        let orientationTarget = interfaceOrientation;
        UIDevice.current.setValue(orientationTarget.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation();
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false;
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .landscape;
        }
    }
}
