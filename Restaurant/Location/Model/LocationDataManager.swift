//
//  LocationDataManager.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation
class LocationDataManager {
    private var locations: [String] = []


    init() {
        fetch()
    }

    private func fetch() {
        for location in loadData() {
            if let city = location["city"], let state = location["state"] {
                locations.append("\(city), \(state)")
            }
        }
    }

    func numberOfItems() -> Int {
        return locations.count
    }

    func location(at index: IndexPath) -> String {
        return locations[index.row]
    }
    
    private func loadData() -> [JsonObject] {
        guard let path = Bundle.main.path(forResource: "Locations", ofType: "plist"), let items = NSArray(contentsOfFile: path) else {
            return [[:]]
        }

        return items as! [JsonObject]
    }
}
