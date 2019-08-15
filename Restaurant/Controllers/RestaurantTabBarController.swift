//
//  RestaurantTabBarController.swift
//  Restaurant
//
//  Created by Luiz on 8/14/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

protocol RestaurantTabBarControllerDelegate {
        func setRestaurant(restaurants: [Restaurant]) -> ()
}

class RestaurantTabBarController: UITabBarController, RestaurantTabBarControllerDelegate {
        func setRestaurant(restaurants: [Restaurant]) {
                self.restaurants = restaurants
        }


        override func viewDidLoad() {
                super.viewDidLoad()

                // Do any additional setup after loading the view.
        }

        var restaurants = [Restaurant]()


         // MARK: - Navigation

         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                dump(self.viewControllers)
         }


        

}
