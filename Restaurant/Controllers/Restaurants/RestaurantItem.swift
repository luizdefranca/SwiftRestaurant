//
//  RestaurantItem.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit
import MapKit
class RestaurantItem: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let latitude = lat, let longitude = long else {
            return CLLocationCoordinate2D()
        }
        return CLLocationCoordinate2D(latitude: latitude  , longitude: longitude)
    }

    var subtitle : String? {
        if cuisines.isEmpty {return ""}
        else if cuisines.count == 1 { return cuisines.first}
        else { return cuisines.joined(separator: " | ")}
    }

    var title: String? {
        return name
    }
    
    var name: String?
    var cuisines: [String] = []
    var lat : Double?
    var long: Double?
    var address: String?
    var postalCode: String?
    var state: String?
    var imageURL: String?

    init(dict : JsonObject) {

        if let lat = dict["lat"] as? Double, let long = dict["long"] as? Double {
            self.lat = lat
            self.long = long
        }
        if let name = dict["name"] as? String { self.name = name}
        if let address = dict["address"] as? String { self.address = address}
        if let postalCode = dict["postalCode"] as? String {self.postalCode = postalCode}
        if let cuisines = dict["cuisines"] as? [String] { self.cuisines = cuisines}
        if let state = dict["state"] as? String { self.state = state}
        if let imageURL = dict["image_url"] as? String {self.imageURL = imageURL}
    }


}
