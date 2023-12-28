//
//  ViewModelType.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit


protocol ViewModelType {
    
    associatedtype Dependency;
    
    associatedtype Bindings
    
    init(dependency: Dependency, bindings: Bindings);
    
}

enum Attachable<VM: ViewModelType> {
    case detached(VM.Dependency)
    case attached(VM.Dependency, VM)
    
    mutating func bind(_ bindings: VM.Bindings) -> VM {
        switch self {
        case let .detached(dependency):
            let vm = VM(dependency: dependency, bindings: bindings)
            self = .attached(dependency, vm);
            return vm;
        case let .attached(dependency, _):
            let vm = VM(dependency: dependency, bindings: bindings);
            self = .attached(dependency, vm);
            return vm;
        }
        
    }
}
