//
//  DataManager.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation

protocol DataManager {
    func load(file name: String) -> [JsonObject]
}

extension DataManager {
    func load(file name: String) -> [JsonObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"), let items = NSArray(contentsOfFile: path) else { return [[:]]}
        return items as! [JsonObject]
    }
}


