//
//  HomeDataModel.swift
//  NyTimes
//
//  Created by Sumit Kumar on 14/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation

struct HomeDataModel:Codable {
    let status : String
    let copyright : String
    let numOfResults : Int
    let results : HomeResult
    
    enum CodingKeys: String, CodingKey {
        case status,copyright,numOfResults = "num_results",results
    }
}
struct HomeResult:Codable {
    let bestsellersDate : String
    let publishedDate : String
    let publishedDateDescription : String
    let previousPublishedDate : String
    let nextPublishedDate : String
    let lists : [ResultList]
    
    enum CodingKeys: String, CodingKey {
        case bestsellersDate = "bestsellers_date"
        case publishedDate = "published_date"
        case publishedDateDescription = "published_date_description"
        case previousPublishedDate = "previous_published_date"
        case nextPublishedDate = "next_published_date"
        case lists
    }
}
struct ResultList:Codable {
    let listId : Int
    let listName : String
    let listNameEncoded : String
    let displayName : String
    let updated : String
    let listImage : String
    let listImageWidth : Int
    let listImageHeight : Int
    let books : [Book]
    
    enum CodingKeys: String, CodingKey {
        case listId = "list_id"
        case listName = "list_name"
        case listNameEncoded = "list_name_encoded"
        case displayName = "display_name"
        case updated
        case listImage = "list_image"
        case listImageWidth = "list_image_width"
        case listImageHeight = "list_image_height"
        case books
    }
}

struct Book:Codable {
    let ageGroup : String?
    let amazonProductUrl : String?
    let articleChapterLink : String?
    let author : String
    let bookImage : String?
    let bookImageWidth : Int?
    let bookImageHeight : Int?
    let bookReviewLink : String?
    let contributor : String
    let contributorNote: String?
    let createdDate : String?
    let description : String
    let firstChapterLink : String?
    let price : Int?
    let primaryIsbn10 : String?
    let primaryIsbn13 : String?
    let bookUri : String?
    let publisher: String
    let rank: Int?
    let rankLastWeek : Int?
    let sundayReviewLink : String?
    let title: String
    let updatedDate : String?
    let weekOnList : Int?
    let buyLinks : [BuyLink]?
    
    enum CodingKeys: String, CodingKey {
        case ageGroup = "age_group"
        case amazonProductUrl = "amazon_product_url"
        case articleChapterLink = "article_chapter_link"
        case author
        case bookImage = "book_image"
        case bookImageWidth = "book_image_width"
        case bookImageHeight = "book_image_height"
        case bookReviewLink = "book_review_link"
        case contributor
        case contributorNote = "contributor_note"
        case createdDate = "created_date"
        case description
        case firstChapterLink = "first_chapter_link"
        case price
        case primaryIsbn10 = "primary_isbn10"
        case primaryIsbn13 = "primary_isbn13"
        case bookUri = "book_uri"
        case publisher
        case rank
        case rankLastWeek = "rank_last_week"
        case sundayReviewLink = "sunday_review_link"
        case title
        case updatedDate = "updated_date"
        case weekOnList = "weeks_on_list"
        case buyLinks = "buy_links"
    }
}

struct BuyLink : Codable {
    let name : String
    let url : String
}
