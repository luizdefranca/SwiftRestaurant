//
//  RestaurantViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/9/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {

    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    var manager = RestaurantDataManager()
    var selectedRestaurant: RestaurantItem?
    var selectedCity: LocationItem?
    var selectedType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createData()
        setupTitle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let location = selectedCity?.city else {
            return
        }
        print("selected city - \(selectedCity as Any)")
        print("selected type - \(selectedType as Any)")
        print(RestaurantAPIManager.loadJSON(file: location))
    }

    func createData() {
        guard let location = selectedCity?.city, let filter = selectedType else {return }
        manager.fetch(by: location, withFilter: filter) {
            if manager.numberOfItems() > 0 {
                restaurantCollectionView.backgroundView = nil
            } else {
                let collectionViewWidth = restaurantCollectionView.frame.width
                let collectionViewHeight = restaurantCollectionView.frame.height
                let view = NoDataView(frame: CGRect(x: 0, y: 0, width: collectionViewWidth, height: collectionViewHeight))
                view.set(title: "Restaurants")
                view.set(desc: "No restaurants found.")
                restaurantCollectionView.backgroundView = view
            }
            restaurantCollectionView.reloadData()
        }
    }

    func setupTitle() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        if let city = selectedCity?.city, let state = selectedCity?.state {
            title = "\(city.uppercased()), \(state.uppercased())"
        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupCollectionView(){
        self.restaurantCollectionView.delegate = self
        self.restaurantCollectionView.dataSource = self
    }
}

extension RestaurantViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! RestaurantCell
        cell.restaurant = manager.restaurantItem(at: indexPath)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension RestaurantViewController: UICollectionViewDelegate {
  
}
