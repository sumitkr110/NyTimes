//
//  BookListTableCell.swift
//  NyTimes
//
//  Created by Sumit Kumar on 15/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import UIKit

class BookListTableCell: UITableViewCell,CellConfigurable {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookPublisherLabel: UILabel!
    @IBOutlet weak var bookContributorLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(viewModel: RowViewModel){
        guard let viewModel = (viewModel as? BookRowVM) else {return}
        if let image = URL.init(string:viewModel.bookImage){
            self.bookImage.downloaded(from: image)
        }
        self.bookTitleLabel.text = viewModel.bookTitle
        self.bookAuthorLabel.text = viewModel.bookAuthor
        self.bookPublisherLabel.text = "Publisher : \(viewModel.bookPublisher)"
        self.bookContributorLabel.text = "Contributor : \(viewModel.bookContributor)"
        self.bookDescriptionLabel.text = viewModel.bookDescription
    }
    
}
