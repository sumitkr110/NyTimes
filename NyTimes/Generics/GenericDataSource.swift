//
//  GenericDataSource.swift
//  NyTimes
//
//  Created by Sumit Kumar on 17/08/20.
//  Copyright © 2020 sumitkr110. All rights reserved.
//

import Foundation
class GenericDataSource<T> : NSObject {
    var data: Observable<[T]> = Observable(value: [])
}
