//
//  RestaurantDetailViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/11/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UITableViewController {

    var selectedRestaurant: RestaurantItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        dump(selectedRestaurant as Any)
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func unwindReviewCancel(segue:UIStoryboardSegue) {}
}
