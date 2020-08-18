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
    
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        return jsonDecoder
    }()
    
    enum Endpoint : String {
        case bookList = "svc/books/v2/lists/overview.json"
    }
    
    private func callAPIWithUrl<T:Codable>(request:URLRequest,completionHandler: @escaping (Result<T,APIServiceError>)->Void)  {
        self.urlSession.dataTask(with: request) { data,response,error in
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

extension APIService : HomeAPIServiceProtocol{
    
    func getBookListForPublishedDate(date publishedDate:String, completionHandler : @escaping(Result<HomeDataModel,APIServiceError>)-> Void)  {
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
        var urlRequest = URLRequest.init(url: bookListUrl)
        urlRequest.httpMethod = "GET"
        self.callAPIWithUrl(request: urlRequest, completionHandler: completionHandler)
    }
}
