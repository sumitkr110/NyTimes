//
//  ViewController.swift
//  NyTimes
//
//  Created by Sumit Kumar on 14/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkManager.shared.getBookListForPublishedDate(date: "2020-08-14") { (result) in
                   switch result{
                   case .success(let homeDataModel):
                       print(homeDataModel)
                   case .failure(let error):
                       print(error)
                   }
               }
    }
}

