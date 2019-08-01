//
//  Restaurant.swift
//  Restaurant
//
//  Created by Luiz on 7/19/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation
import MapKit

class Restaurant: NSObject, MKAnnotation {
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

    var id: String?
    var name: String?
    var cuisines: [String] = []
    var lat : Double?
    var long: Double?
    var address: String?
    var postalCode: String?
    var city: String?
    var imageURL: String?
    var localityVerbose: String?

    init(dict : JsonObject) {

        if let id = dict["id"] as? String {
            self.id = id
        }

        if let location = dict["location"] as? JsonObject {
            if let address = location["address"] as? String {
                self.address = address
            }

            if let city = location["city"] as? String {
                self.city = city
            }

            if let lat = location["latitude"] as? String, let long = location["longitude"] as? String {
                self.lat = Double(lat)
                self.long = Double(long)
            }

            if let localityVerbose = location["locality_verbose"] as? String {
                self.localityVerbose = localityVerbose
            }

            if let postalCode = location["zipcode"] as? String {self.postalCode = postalCode}
        }

        if let name = dict["name"] as? String { self.name = name}


        if let cuisinesSTring = dict["cuisines"] as? String {
            let cuisines = cuisinesSTring.components(separatedBy: ",")
            self.cuisines = cuisines
        }

        if let imageURL = dict["featured_image"] as? String {self.imageURL = imageURL}
    }


}
