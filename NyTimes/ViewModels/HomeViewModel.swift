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
    var sectionVMs = Observable<[SectionViewModel]> (value: [])
    var filteredList = Observable<[SectionViewModel]>(value: [])
    var isLoading = Observable<Bool> (value: true)

    func fetchBookListForDate(date : String)  {
        NetworkManager.shared.getBookListForPublishedDate(date:date) { (result) in
            switch result{
            case .success(let homeDataModel):
                self.buildVMs(homeDataModel: homeDataModel)
                self.isLoading.value = false
            case .failure(let error):
                print(error)
                self.isLoading.value = false
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
        sectionVMs.value = sections
    }
    func filterBooksForSearchText(searchText:String)  {
        
        for section in self.sectionVMs.value{
            self.filterBooksForSectionWithSeachText(section: section.rowViewModels, searchText: searchText)
        }
       
    }
    func filterBooksForSectionWithSeachText(section:[BookRowVM],searchText:String)->[BookRowVM] {
        var filteredSections = [BookRowVM]()
        filteredSections = section.filter { (book: BookRowVM) -> Bool in
          return book.bookTitle.lowercased().contains(searchText.lowercased())
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
