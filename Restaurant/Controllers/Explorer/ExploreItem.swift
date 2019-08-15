//
//  ExploreItem.swift
//  Restaurant
//
//  Created by Luiz on 7/9/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation
typealias JsonObject = [String: Any]
struct ExploreItem {
        var name : String
        var image : String
        var id: Int
        

        init(dict : JsonObject) {
                self.name = dict["name"] as! String
                self.image = dict["image"] as! String
                self.id = dict["id"] as? Int ?? 0
        }
}
