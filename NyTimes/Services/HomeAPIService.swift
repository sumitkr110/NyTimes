//
//  HomeAPIService.swift
//  NyTimes
//
//  Created by Sumit Kumar on 17/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
class HomeAPIService{
    enum Endpoint : String {
        case bookList = "svc/books/v2/lists/overview.json"
    }
    class func getBookListForPublishedDate(date publishedDate:String, completionHandler : @escaping(Result<HomeDataModel,APIServiceError>)-> Void)  {
        guard let url = URL(string:Constant.baseUrl)?.appendingPathComponent(Endpoint.bookList.rawValue)else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        guard var urlComponents = URLComponents (url: url, resolvingAgainstBaseURL: true) else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        let queryItems = [URLQueryItem(name:Constant.publishedDateKey, value: publishedDate), URLQueryItem(name: Constant.apiKey, value: Constant.apiKeyValue)]
        urlComponents.queryItems = queryItems
        guard  let bookListUrl = urlComponents.url  else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        APIService.callAPIWithUrl(url: bookListUrl, completionHandler: completionHandler)
    }
}
