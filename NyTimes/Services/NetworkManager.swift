//
//  NetworkManager.swift
//  NyTimes
//
//  Created by Sumit Kumar on 14/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init (){}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string:Constant.baseUrl)
    private let apiKey = Constant.apiKeyValue
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        return jsonDecoder
    }()
    
    enum APIServiceError : Error {
        case noData
        case decodeError
        case invalidResponse
        case apiError
        case invalidEndpoint
    }
    enum Endpoint : String {
        case bookList = "svc/books/v2/lists/overview.json"
    }
    private func callAPIWithUrl<T:Codable>(url:URL,completionHandler: @escaping (Result<T,APIServiceError>)->Void)  {
           urlSession.dataTask(with: url) { data,response,error in
               if error != nil
               {
                   completionHandler(.failure(APIServiceError.apiError))
               }
               guard let responseStatusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= responseStatusCode else {
                   completionHandler(.failure(APIServiceError.invalidResponse))
                   return
               }
               do {
                   let value = try self.jsonDecoder.decode(T.self, from: data!)
                   completionHandler(.success(value))
               }
               catch{
                   print(error)
                   completionHandler(.failure(APIServiceError.decodeError))
               }
           }.resume()
       }
       
    func getBookListForPublishedDate(date publishedDate:String, completionHandler : @escaping(Result<HomeDataModel,APIServiceError>)-> Void)  {
        guard let url = self.baseURL?.appendingPathComponent(Endpoint.bookList.rawValue)else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        guard var urlComponents = URLComponents (url: url, resolvingAgainstBaseURL: true) else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        let queryItems = [URLQueryItem(name:Constant.publishedDateKey, value: publishedDate), URLQueryItem(name: Constant.apiKey, value: apiKey)]
        urlComponents.queryItems = queryItems
        guard  let bookListUrl = urlComponents.url  else {
            completionHandler(.failure(APIServiceError.invalidEndpoint))
            return
        }
        self.callAPIWithUrl(url: bookListUrl, completionHandler: completionHandler)
       }
    
       func getImageFromUrl(url: URL, completionHandler : @escaping (Data?,Error?)->Void)  {
           urlSession.dataTask(with: url) { data,response,error in
               if error == nil && (data != nil){
                   completionHandler(data,nil)
               }
               else
               {
                   completionHandler(nil,error)
               }
           }.resume()
       }
}

