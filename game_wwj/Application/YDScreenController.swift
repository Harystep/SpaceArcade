//
//  YDScreenController.swift
//  game_wwj
//
//  Created by oneStep on 2023/11/29.
//

import UIKit
import RxSwift
import SnapKit

class YDScreenController: UIViewController {

    var appCoordinator: AppCoordinator!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoIv:UIImageView = UIImageView(image: UIImage(named: "logo_screen_icon"))
        logoIv.frame = self.view.bounds
        logoIv.contentMode = .scaleAspectFill
        self.view.addSubview(logoIv)
        
        let startBtn:UIButton = UIButton()
        self.view.addSubview(startBtn)
        startBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom).inset(50)
            make.width.equalTo(153)
            make.height.equalTo(51)
        }
        startBtn.setBackgroundImage(UIImage(named: "logo_jump_bg_icon"), for: .normal)
        startBtn.setTitle("进入游戏", for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.titleLabel?.font = UIFont(name: "ZhenyanGB", size: 20)
        startBtn.addTarget(self, action: #selector(startBtnClick), for: .touchUpInside)
    }
    
    @objc func startBtnClick () {
        self.appCoordinator.start().subscribe().disposed(by: self.disposeBag);
    }
  
}
