//
//  LocationDataManager.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation
class LocationDataManager {
    private var locations: [LocationItem] = []


    init() {
        fetch()
    }

    private func fetch() {
        for location in loadData() {
            locations.append(LocationItem(dict: location))
        }
    }

    func numberOfItems() -> Int {
        return locations.count
    }

    func location(at index: IndexPath) -> LocationItem {
        return locations[index.row]
    }
    
    private func loadData() -> [JsonObject] {
        guard let path = Bundle.main.path(forResource: "Locations", ofType: "plist"), let items = NSArray(contentsOfFile: path) else {
            return [[:]]
        }

        return items as! [JsonObject]
    }

    func findLocation(By name: String) -> (isFound: Bool, position: Int) {
        guard let index = locations.firstIndex(where: {$0.city == name}) else { return (isFound: false, position: 0) }
        return (isFound: true, position: index)
    }
}
