//
//  MapDataManager.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit
import MapKit
class MapDataManager : DataManager {
    fileprivate var items: [Restaurant] = []



    var annotations: [Restaurant] {
        return items
    }


    func fetch( completion: (_ annotations: [Restaurant]) -> ()){
        for data in load(file: "MapLocations") {
            items.append(Restaurant(dict: data))
        }
        completion(items)
    }

    func currentRegion(latDelta: CLLocationDegrees, longDelta: CLLocationDegrees) -> MKCoordinateRegion {

        guard  let item = items.first  else {
            return MKCoordinateRegion()
        }
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        return MKCoordinateRegion(center: item.coordinate, span: span)
    }

}
