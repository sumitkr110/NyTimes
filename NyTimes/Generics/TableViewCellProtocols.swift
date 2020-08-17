//
//  CellConfigurable.swift
//  NyTimes
//
//  Created by Sumit Kumar on 15/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
protocol CellConfigurable {
    func setup(viewModel: RowViewModel) // Provide a generic function for table row set up
}
protocol RowViewModel {
}

