//
//  MockHomeAPIServiceClient.swift
//  NyTimesTests
//
//  Created by Sumit Kumar on 19/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import XCTest
@testable import NyTimes

class MockHomeAPIServiceClient{
    var shouldReturnError = false
    var getBookListWascalled = false
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        return jsonDecoder
    }()
    func reset(){
        shouldReturnError = false
        getBookListWascalled = false
    }
    convenience init(){
        self.init(false)
    }
    init(_ shouldReturnError:Bool) {
        self.shouldReturnError = shouldReturnError
    }
    var mockBookListData : Data?{
        getDataFromJson()
    }
    
}
extension MockHomeAPIServiceClient : HomeAPIServiceProtocol{
    func getBookListForPublishedDate(date publishedDate: String, completionHandler: @escaping (Result<HomeDataModel, APIServiceError>) -> Void) {
        XCTAssertTrue(isValidDate(dateString: publishedDate), "Published date passed as parameter is either invalid or in incorrect format")
        if !isValidDate(dateString: publishedDate)
        {
            completionHandler(.failure(.invalidEndpoint))
        }
        getBookListWascalled = true
        if shouldReturnError{
            completionHandler(.failure(.apiError))
        }else{
            if let data = mockBookListData{
                do{
                    let value = try self.jsonDecoder.decode(HomeDataModel.self, from: data)
                    completionHandler(.success(value))
                }catch{
                    completionHandler(.failure(.decodeError))
                }
            }else{
                completionHandler(.failure(.noData))
            }
        }
    }
    func getDataFromJson() -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: "HomeData", ofType: "json") else { return nil}
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
    func isValidDate(dateString: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        if let _ = dateFormatterGet.date(from: dateString) {
            return true
        } else {
            return false
        }
    }
}
