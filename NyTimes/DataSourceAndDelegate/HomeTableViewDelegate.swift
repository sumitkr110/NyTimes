//
//  HomeTableViewDelegate.swift
//  NyTimes
//
//  Created by Sumit Kumar on 17/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
class HomeTableViewDelegate : GenericDataSource<SectionViewModel>,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constant.tableViewSectionHeight)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: CGFloat(Constant.sectionHeaderLabelMargin), y:  CGFloat(Constant.sectionHeaderLabelMargin), width: tableView.frame.width, height: (CGFloat(Constant.tableViewSectionHeight) - CGFloat(Constant.sectionHeaderLabelMargin))))
        headerView.backgroundColor = Constant.tableViewSectionBackgroundColor
        let label = UILabel()
        label.frame = headerView.frame
        if data.value.count>0{
            label.text = data.value[section].headerTitle
        }
        label.font = Constant.tableViewSectionTitleFont
        headerView.addSubview(label)
        return headerView
    }
}

