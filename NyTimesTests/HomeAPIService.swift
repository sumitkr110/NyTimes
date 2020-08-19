//
//  HomeAPIService.swift
//  NyTimesTests
//
//  Created by Sumit Kumar on 19/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import XCTest
@testable import NyTimes
class HomeAPIServiceTests : XCTestCase{
    let apiService = MockHomeAPIServiceClient()
    override func setUpWithError() throws {
           // Put setup code here. This method is called before the invocation of each test method in the class.
       }
    func testGetBookListForPublishedDateResponse()  {
        
        let expectation = self.expectation(description: "Home Data Response Successful")
        //Uncomment for testing API failure flow
        //apiService.shouldReturnError = true
        apiService.getBookListForPublishedDate(date:"2020-08-14") { result in
            switch result{
            case .failure (let error):
                XCTFail(error.localizedDescription)
                XCTAssertNil(error)
            case .success (let homeData):
                XCTAssertNotNil(homeData)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
       override func tearDownWithError() throws {
           // Put teardown code here. This method is called after the invocation of each test method in the class.
       }

}
