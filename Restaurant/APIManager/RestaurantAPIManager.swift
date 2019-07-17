//
//  APIManager.swift
//  Restaurant
//
//  Created by Luiz on 7/15/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation
struct RestaurantAPIManager {
    static func loadJSON(file name: String) -> [JsonObject] {
        var items = [JsonObject]()
        guard let path = Bundle.main.path(forResource: name, ofType: "json"), let data = NSData(contentsOfFile: path) else {return [[:]]}

        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options:  .allowFragments) as AnyObject
            if let restaurants = json as? [JsonObject] {
                items = restaurants
            }

        } catch  {
            print("error serializing JSON: \(error) - \(#file) - \(#line)")
        }

        return items
    }
}

