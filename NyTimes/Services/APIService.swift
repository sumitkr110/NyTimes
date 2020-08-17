//
//  NetworkManager.swift
//  NyTimes
//
//  Created by Sumit Kumar on 14/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
enum APIServiceError : Error {
       case noData
       case decodeError
       case invalidResponse
       case apiError
       case invalidEndpoint
   }
class APIService{
    private static let urlSession = URLSession.shared
    private static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        return jsonDecoder
    }()
    class func callAPIWithUrl<T:Codable>(url:URL,completionHandler: @escaping (Result<T,APIServiceError>)->Void)  {
        APIService.urlSession.dataTask(with: url) { data,response,error in
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
       
    
    
}

