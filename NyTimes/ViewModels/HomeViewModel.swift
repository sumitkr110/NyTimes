//
//  HomeViewModel.swift
//  NyTimes
//
//  Created by Sumit Kumar on 15/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
import UIKit
class HomeViewModel {
    var dataSource : GenericDataSource<SectionViewModel>?
    var delegate : GenericDataSource<SectionViewModel>?
    var bookList =  [SectionViewModel]()
    var filteredList = Observable<[SectionViewModel]> (value: [])
    var isLoading = Observable<Bool> (value: true)
    var isFiltering: Bool = false
    var bookCount = Observable<Int> (value: 0)
    init(dataSource : GenericDataSource<SectionViewModel>?,delegate : GenericDataSource<SectionViewModel>?) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    func fetchBookListForDate(date : String)  {
        HomeAPIService.getBookListForPublishedDate(date:date) {[weak self] (result) in
            switch result{
            case .success(let homeDataModel):
                self?.buildVMs(homeDataModel: homeDataModel)
                self?.bookCount.value = homeDataModel.numOfResults
                self?.isLoading.value = false
            case .failure(let error):
                print(error)
                self?.isLoading.value = false
                switch error {
                case .decodeError:
                    self?.bookCount.value = 0//Setting the viewModel bookCount to 0 to show book unavailability alert as we are getting inconsistent response from backend. In case of Empty result we are getting Array in response but we are expecting dictionary
                default:
                    ""
                }
            }
        }
    }
    func buildVMs(homeDataModel:HomeDataModel) {
        var sections = [SectionViewModel]()
        let resultList = homeDataModel.results.lists
            for list in resultList{
                var rows = [BookRowVM]()
                for book in list.books {
                    let row = BookRowVM(bookTitle:book.title , bookAuthor: book.author, bookPublisher: (book.publisher), bookContributor: (book.contributor), bookDescription: book.description, bookImage: book.bookImage!)
                    rows.append(row)
                }
                let section = SectionViewModel(rowViewModels: rows, headerTitle: list.displayName)
                sections.append(section)
            }
        bookList = sections
        self.dataSource?.data.value = sections
        self.delegate?.data.value = sections
    }
    func filterBooksForSearchText(searchText:String)  {
        self.isFiltering = searchText.count>0 ? true : false
        self.filteredList.value = [SectionViewModel]()
        for section in self.bookList{
            let filteredSection = self.filterBooksForSectionWithSeachText(section: section.rowViewModels, searchText: searchText)
            if(filteredSection.count>0){
                let sectionVM = SectionViewModel(rowViewModels: filteredSection, headerTitle: section.headerTitle)
                self.filteredList.value.append(sectionVM)
            }
            if isFiltering{
                self.dataSource?.data.value = self.filteredList.value
            }
            else{
                self.dataSource?.data.value = self.bookList
            }
        }
    }
    func filterBooksForSectionWithSeachText(section:[BookRowVM],searchText:String)->[BookRowVM] {
        var filteredSections = [BookRowVM]()
        filteredSections = section.filter { (book: BookRowVM) -> Bool in
            return book.bookTitle.lowercased().contains(searchText.lowercased()) || book.bookAuthor.lowercased().contains(searchText.lowercased()) || book.bookPublisher.lowercased().contains(searchText.lowercased()) || book.bookContributor.lowercased().contains(searchText.lowercased())
        }
        return filteredSections
    }
}
struct BookRowVM:RowViewModel
{
    let bookTitle : String
    let bookAuthor : String
    let bookPublisher : String
    let bookContributor : String
    let bookDescription : String
    let bookImage : String
}
struct SectionViewModel {
    let rowViewModels: [BookRowVM]
    let headerTitle: String
}
