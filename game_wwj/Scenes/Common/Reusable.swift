//
//  Reusable.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/7.
//

import UIKit

protocol Reusable {
    static var reuseID: String {get}
}
extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UIViewController: Reusable {
    class func instance() -> Self {
        let storyboard = UIStoryboard(name: reuseID, bundle: nil)
        return storyboard.instantiateViewController()
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.reuseID) as? T else {
            fatalError("Unable to instantiate view controller: \(T.self)")
        }
        return viewController
    }
}
