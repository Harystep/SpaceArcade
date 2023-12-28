//
//  CoordinatorType.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit
import RxSwift

protocol CoordinatorType {
    
    associatedtype CoordinationResult
    
    var identifier: UUID { get }
    
    func start() -> Observable<CoordinationResult>
    
}
