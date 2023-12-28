//
//  SDCollectionViewModel.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/11.
//

import UIKit

protocol SDCollectionViewModel {
    func getCellIdentifier() -> String;
}

protocol SDTableViewModel {
    func getCellIdentifier() -> String;
}
