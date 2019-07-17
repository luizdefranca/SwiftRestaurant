//
//  LocationViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var locationTableView: UITableView!
    let locations = ["Aspen", "Boston", "Charleston", "Chicago", "Houston", "Las Vegas", "Los Angeles", "Miami", "New Orleans", "New York", "Philadelphia", "Portland", "San Antonio", "San Francisco", "Washington District of Columbia"]
    var selectedCity: LocationItem?
    let manager = LocationDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTableView.dataSource = self
        self.locationTableView.delegate = self

    }

    func set(selected cell: UITableViewCell, at indexPath: IndexPath) {
        if let city = selectedCity?.city {
            let data = manager.findLocation(By: city)
            if data.isFound {
                if indexPath.row == data.position {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        } else { cell.accessoryType = .none}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as UITableViewCell
        let location = manager.location(at: indexPath)
        cell.textLabel?.text = location.full
        return cell
    }

}

extension LocationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedCity = manager.location(at: indexPath)
            tableView.reloadData()
        }
    }
}

