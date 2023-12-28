//
//  ViewModelAttaching.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit
import RxSwift

protocol ViewModelAttaching: class {
    
    associatedtype ViewModel: ViewModelType
    
    var bindings: ViewModel.Bindings { get }
    var viewModel: Attachable<ViewModel>! { get set }
    
    func attach(wrapper: Attachable<ViewModel>) -> ViewModel
    
    func bind(viewModel: ViewModel) -> ViewModel
    
}

extension ViewModelAttaching where Self: UIViewController {
    
    @discardableResult
    func attach(wrapper: Attachable<ViewModel>) -> ViewModel {
        viewModel = wrapper;
        loadViewIfNeeded()
        let vm = viewModel.bind(bindings);
        return bind(viewModel: vm);
    }
}
