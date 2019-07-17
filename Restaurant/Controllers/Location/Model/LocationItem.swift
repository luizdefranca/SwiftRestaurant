//
//  LocationItem.swift
//  Restaurant
//
//  Created by Luiz on 7/15/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation

struct LocationItem {
    var state: String?
    var city: String?
}

extension LocationItem {
    init(dict:JsonObject) {
        self.state  = dict["state"] as? String
        self.city = dict["city"] as? String
    }

    var full: String {
        guard let city = self.city, let state = self.state else { return "" }
        return "\(city), \(state)"
    }
}
