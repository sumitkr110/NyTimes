//
//  HomeDataSource.swift
//  NyTimes
//
//  Created by Sumit Kumar on 17/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
class HomeTableViewDataSource : GenericDataSource<SectionViewModel>,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value[section].rowViewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  rowVM = data.value[indexPath.section].rowViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:BookListTableCell.cellIdentifier(), for: indexPath)
        if let cell = cell as? CellConfigurable{
            cell.setup(viewModel: rowVM)
        }
        return cell
    }
}
