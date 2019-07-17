//
//  RestaurantDataManager.swift
//  Restaurant
//
//  Created by Luiz on 7/15/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation

class RestaurantDataManager {

    private var items: [RestaurantItem] = []
    
    func fetch(by location: String, withFilter: String = "All", onComplete:() -> Swift.Void){
        var restaurants: [RestaurantItem] = []


        for restaurant in RestaurantAPIManager.loadJSON(file: location)  {
            restaurants.append(RestaurantItem(dict: restaurant))
        }

        if withFilter != "All" {
            items = restaurants.filter({ $0.cuisines.contains(withFilter)})
        } else {
            items = restaurants
        }
        onComplete()
    }

    func numberOfItems() -> Int {
        return items.count
    }

    func restaurantItem(at index: IndexPath) -> RestaurantItem {
        let row = index.item
        return items[row]
    }
}
