//
//  APIManager.swift
//  Restaurant
//
//  Created by Luiz on 7/15/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
struct RestaurantAPIManager {

    private static let apiKey = "350e113040405bfc4ff8bbb2b3513b43"

    private static let headers: HTTPHeaders = [
        "user-key": apiKey,
        "Accept": "application/json"
    ]

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

    static func fetchRestaurant(byLatitude lat: Double, andLongitude lon: Double, onComplete: @escaping ([JsonObject]? ) -> ()) {
        var restaurants = [JsonObject]()
        let url = "https://developers.zomato.com/api/v2.1/search?lat=\(lat)&lon=\(lon)&radius=1000"
        let request = Alamofire.request("https://mashape-community-urban-dictionary.p.mashape.com/define?term=smh", headers: headers)
            .responseJSON { response in

                if response.error != nil {
                    print("request error: \(response.error.debugDescription) - \(#file) - \(#line)")
                    onComplete(nil)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Response Error: \(#file) - \(#function) - \(#line)")
                    onComplete(nil)
                    return
                }

                guard httpResponse.statusCode == 200 else {
                    print(response.debugDescription)
                    print("Server Error - code:\(httpResponse.statusCode) -  \(#file) - \(#function) - \(#line)")
                    onComplete(nil)
                    return
                }


                guard let json = response.result.value as? JsonObject else {
                    print("error loading json - \(#file) \(#line)")
                    onComplete(nil)
                    return
                }

                guard let restaurantArray = json["restaurants"] as? [JsonObject] else {
                    print("error loading dictionary \(#file) \(#line)")
                    onComplete(nil)
                    return
                }

                for restaurantObject in restaurantArray {
                    
                }

        }

    }
}

import Foundation
protocol JSONDecodable {
    init (_ decoder: JSONDecoder) throws
}

typealias JSONObject = [String: Any]

class JSONDecoder
{
    let jsonObject: JSONObject
    init(_ jsonObject: JSONObject)
    {
        self.jsonObject = jsonObject
    }
}

func parse<T>(_ data: Data) throws -> [T] where T: JSONDecodable
{
    let JSONObject: [JSONObject] = try deserialize(data)
    return try JSONObject.map(decode)
}

func deserialize(_ data: Data) throws -> [JSONObject]
{
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    guard let objects = json as? [JSONObject] else {
        return []
    }
    return objects
}

func decode<T>(_ jsonObject: JSONObject) throws -> T where T: JSONDecodable
{
    return try T.init(JSONDecoder(jsonObject))
}

