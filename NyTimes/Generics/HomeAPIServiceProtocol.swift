//
//  HomeAPIServiceProtocol.swift
//  NyTimes
//
//  Created by Sumit Kumar on 19/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
protocol HomeAPIServiceProtocol {
    func getBookListForPublishedDate(date publishedDate:String, completionHandler : @escaping(Result<HomeDataModel,APIServiceError>)-> Void)
}

