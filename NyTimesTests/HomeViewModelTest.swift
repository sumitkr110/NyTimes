//
//  HomeViewModelTest.swift
//  NyTimesTests
//
//  Created by Sumit Kumar on 19/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import XCTest
@testable import NyTimes
class HomeViewModelTest: XCTestCase {
    
    var homeViewModel : HomeViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let apiService = MockHomeAPIServiceClient()
        let dataSource = HomeTableViewDataSource()
        let delegate = HomeTableViewDelegate()
        homeViewModel = HomeViewModel.init(dataSource: dataSource, delegate: delegate, apiService: apiService)
        getHomeDataForSearch()
    }
    
    func testHomeViewModelFetchDataWithFutureDate()  {
        // let futureDate = "2021-07-22"
        // Passing future will fail the test case
        homeViewModel.fetchBookListForDate(date: "2020-07-22")
        
    }
    
    func testHomeViewModelFetchDataWithInvalidDate()  {
        // let invalidDate = "2019-08-40"
        // Passing invalidDate will fail the test case
        homeViewModel.fetchBookListForDate(date: "2020-07-22")
        
    }
    
    func testHomeViewModelFetchDataWithIncorrectDateFormat()  {
        // let incorrectDateFormat = "20-08-2019"
        // Passing incorrectDateFormat will fail the test case
        //Expects Date in yyyy-MM-dd format
        homeViewModel.fetchBookListForDate(date:"2020-08-19" )
        
    }
    
    func getHomeDataForSearch() {
        homeViewModel.apiService?.getBookListForPublishedDate(date: "2020-08-19", completionHandler: { [weak self] (result) in
            switch result{
            case .success(let homeDataModel):
                self?.homeViewModel.buildVMs(homeDataModel: homeDataModel)
                XCTAssertNotNil(self?.homeViewModel.bookList)
                XCTAssertNotNil(self?.homeViewModel.delegate)
                XCTAssertNotNil(self?.homeViewModel.dataSource)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
    }
    
    func testSearch() {
        homeViewModel.filterBooksForSearchText(searchText: "The")
        XCTAssertLessThanOrEqual(homeViewModel.filteredList.value.count, homeViewModel.bookList.count)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
