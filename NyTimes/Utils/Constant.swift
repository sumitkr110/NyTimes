//
//  Constants.swift
//  NyTimes
//
//  Created by Sumit Kumar on 14/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
struct Constant {
    static let baseUrl = "https://api.nytimes.com"
    static let apiKeyValue = "76363c9e70bc401bac1e6ad88b13bd1d"
    static let publishedDateKey = "published_date"
    static let apiKey = "api-key"
    static let activityBackgroundViewTag = 475647
    static let dateFormat = "yyyy-MM-dd"
    static let datePickerViewHeight = 260.0
    static let tableViewSectionHeight = 50.0
    static let toolBarHeight = 44.0
    static let sectionHeaderLabelMargin = 8.0
    static let tableViewSectionBackgroundColor = UIColor.init(displayP3Red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    static let tableViewSectionTitleFont = UIFont.init(name: "Verdana-Bold", size: 18)
    static let noBookAlertMessage = "There are no books available for the selected date.Would you like to select a different date?"
    static let noBookAlertTitle = "Sorry"
    static let generalAlertMessage = "Something went wrong.Try again after sometime"
    static let generalAlertTitle = "Error"
}


