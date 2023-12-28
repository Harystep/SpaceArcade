//
//  AppDependency.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit

protocol HadUserManager {
    var usermanager: SDUserManager { get }
}

protocol HadClient {
    var client : APIClient { get }
}

protocol HadHomeService {
    var homeService: SDHomeServiceType { get }
}

protocol HadCustomService {
    var customService: SDCustomServiceType { get }
}

protocol HadUserInfoServce {
    var userInfoService: SDUserInfoServiceType { get }
}


protocol HadRechargeService {
    var rechargeService: SDRechargeServiceType { get }
}


protocol HadTCPClientService {
    var tcpClientService: SDTCPClientServiceType { get }
}


struct AppDependency: HadUserManager, HadClient, HadHomeService, HadCustomService, HadUserInfoServce, HadRechargeService, HadTCPClientService{
    var rechargeService: SDRechargeServiceType
    
    let customService: SDCustomServiceType
    
    let client: APIClient;
    
    let usermanager: SDUserManager;
    
    let homeService: SDHomeServiceType;
    
    let userInfoService: SDUserInfoServiceType;
    let tcpClientService: SDTCPClientServiceType

    
    init() {
        
        self.usermanager = SDUserManager();
        
        self.client = APIClient();
    
        self.homeService = SDHomeService.init(client: self.client, userService: self.usermanager);
        
        self.customService = SDCustomService(client: self.client);
        
        self.userInfoService = SDUserInfoService(client: self.client, userService: self.usermanager);
        
        self.rechargeService = SDRechargeService(client: self.client, userService: self.usermanager);
        
        self.tcpClientService = SDTCPClientService();


    }
}
