//
//  SDCollectionItemType.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/11.
//

import UIKit

protocol SDCollectionItemType: UICollectionViewCell {
    func bind(to viewModel: SDCollectionViewModel);
}

protocol SDTableViewCellType: UITableViewCell {
    func bind(to viewModel: SDTableViewModel);
}

