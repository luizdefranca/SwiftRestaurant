//
//  ExploreDataManager.swift
//  Restaurant
//
//  Created by Luiz on 7/9/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation

class ExploreDataManager : DataManager {

    fileprivate var items: [ExploreItem] = []

    init() {
        fetch()
    }
    func fetch() {
        for data in load(file: "ExploreData") {
            items.append(ExploreItem(dict: data))
        }
    }

    func numberOfItems() -> Int {
        return items.count
    }

    func explore(at index: IndexPath) -> ExploreItem? {
        return items[index.item]
    }
}
