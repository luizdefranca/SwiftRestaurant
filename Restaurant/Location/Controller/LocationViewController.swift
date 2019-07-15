//
//  LocationViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var locationTableView: UITableView!
    let locations = ["Aspen", "Boston", "Charleston", "Chicago", "Houston", "Las Vegas", "Los Angeles", "Miami", "New Orleans", "New York", "Philadelphia", "Portland", "San Antonio", "San Francisco", "Washington District of Columbia"]

    let manager = LocationDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTableView.dataSource = self
        self.locationTableView.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = manager.location(at: indexPath)
        return cell
    }
}

