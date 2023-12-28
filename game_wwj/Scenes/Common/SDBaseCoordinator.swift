//
//  SDBaseCoordinator.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit

import RxSwift

class SDBaseCoordinator<ResultType>: CoordinatorType {
    typealias CoordinationResult = ResultType;
    
    internal let identifier = UUID();
    
    let disposeBag = DisposeBag();
    
    private var childCoordinators = [UUID: Any]();
    
    func start() -> RxSwift.Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
    
    private func store<T: CoordinatorType>(coordinator: T) {
        childCoordinators[coordinator.identifier] = coordinator;
    }
    
    private func free<T: CoordinatorType>(coordiator: T) {
        childCoordinators[coordiator.identifier] = nil;
    }
    
    func coordinate<T: CoordinatorType, U>(to coordinator: T) -> Observable<U> where U == T.CoordinationResult {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: {[weak self] _ in self?.free(coordiator: coordinator)})
    }
    
}

extension SDBaseCoordinator: CustomStringConvertible {
    var description: String {
        return "\(type(of: self))"
    }
}
