//
//  RestaurantDataManager.swift
//  Restaurant
//
//  Created by Luiz on 7/15/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation
import MapKit

class RestaurantDataManager {

     var items: [Restaurant]  = []

    
//    func fetch(by location: String, withFilter: String = "All", onComplete:() -> Swift.Void){
//        var restaurants: [RestaurantItem] = []
//
//
//        for restaurant in RestaurantAPIManager.loadJSON(file: location)  {
//            restaurants.append(RestaurantItem(dict: restaurant))
//        }
//
//        if withFilter != "All" {
//            items = restaurants.filter({ $0.cuisines.contains(withFilter)})
//        } else {
//            items = restaurants
//        }
//        onComplete()
//    }

    func fetchRestaurants(by location:CLLocationCoordinate2D, start: Int = 0, withFilter: String = "All", onComplete:([Restaurant]) -> ()) {
        var restaurantsT: [Restaurant] = []

        defer {
                onComplete(restaurantsT)
        }
        RestaurantAPIManager.fetchRestaurant(byLatitude: location.latitude, andLongitude: location.longitude) { restaurantsItems in
            guard let restaurantsItems = restaurantsItems else {
                print("restaurant array is null - \(#file) - \(#line)")
                return
            }

                restaurantsT = restaurantsItems

        }
//        onComplete(restaurantsT)
    }

    func numberOfItems() -> Int {
        return items.count
    }

    func restaurantItem(at index: IndexPath) -> Restaurant {
        let row = index.item
        return items[row]
    }


}
