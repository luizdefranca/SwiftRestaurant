//
//  RestaurantViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/9/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit
import MapKit
class RestaurantViewController: UIViewController {

        @IBOutlet weak var restaurantCollectionView: UICollectionView!

        var manager = RestaurantDataManager()

        //    var selectedRestaurant: RestaurantItem?
        var selectedRestaurant: Restaurant?
        var selectedCity: LocationItem?
        var selectedType: String?
        var numberOfLoadedRestaurants: Int = 0
        var restaurants : [Restaurant] = []
        //Uploading data
        var isMoreDataLoading = false
        var loadingMoreView: InfiniteScrollActivityView?

        //Location
        var currentLocation: CLLocation = CLLocation()


        override func viewDidLoad() {
                super.viewDidLoad()
                setupCollectionView()
                createData()
                //        setupTitle()
                //                updateView()
                setupInfiniteScrollLoadingIndicator()



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
        //


        func createData() {
                guard  let filter = selectedType else {return }
                let location : CLLocationCoordinate2D = currentLocation.coordinate
                RestaurantAPIManager.fetchRestaurant(byLatitude: location.latitude, andLongitude: location.longitude) { restaurants in
                        guard let restaurants = restaurants else {
                                return
                        }
                        DispatchQueue.main.async {
                                self.restaurants = restaurants
                                self.updateView()
                        }


                }

                //                self.manager.fetchRestaurants(by: location, withFilter: filter) { restaurants in
                //                        DispatchQueue.main.async {
                //                        }
                //
                //                }

        }

        func updateView() {
                if self.restaurants.count > 0 {
                        self.restaurantCollectionView.backgroundView = nil
                } else {
                        let collectionViewWidth = self.restaurantCollectionView.frame.width
                        let collectionViewHeight = self.restaurantCollectionView.frame.height
                        let view = NoDataView(frame: CGRect(x: 0, y: 0, width: collectionViewWidth, height: collectionViewHeight))
                        view.set(title: "Restaurants")
                        view.set(desc: "No restaurants found.")
                        self.restaurantCollectionView.backgroundView = view
                        //update loadedRestaurant

                }
                //                        self.numberOfLoadedRestaurants = self.manager.numberOfItems()
                //                        self.restaurants = self.manager.items
                self.restaurantCollectionView.reloadData()
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

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

                guard let indexPath = restaurantCollectionView.indexPathsForSelectedItems?.first else {
                        print("There is not selected indexPath")
                        return
                }
                selectedRestaurant = restaurants[indexPath.row]
                //                        manager.restaurantItem(at: indexPath)
                switch segue.identifier {
                case Segue.showDetailAfterRestaurantList.rawValue:
                        if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? RestaurantDetailViewController, let restaurant = selectedRestaurant {
                                vc.selectedRestaurant = restaurant
                                dump(selectedRestaurant)
                        }
                default:
                        print("There is not segue")
                }
        }

        func loadMoreData(location: CLLocationCoordinate2D, start: Int?, filter: String?){
                manager.fetchRestaurants(by: location, start: start ?? 0, withFilter: filter ?? "All") { restaurants in

                        self.isMoreDataLoading = false
                        self.loadingMoreView!.stopAnimating()

                        //update datamodel
                        //
                        //insert values in the collectionView
                        // restaurantCollectionView.insertItems(at: <#T##[IndexPath]#>)


                }
        }
}

extension RestaurantViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return restaurants.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! RestaurantCell
                cell.restaurant = restaurants[indexPath.row]
                return cell
        }


        func numberOfSections(in collectionView: UICollectionView) -> Int {
                return 1
        }
}

extension RestaurantViewController: UICollectionViewDelegate {

}

extension RestaurantViewController: UIScrollViewDelegate {

        func setupInfiniteScrollLoadingIndicator(){
                let frame = CGRect(x: 0, y: restaurantCollectionView.contentSize.height, width: restaurantCollectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView = InfiniteScrollActivityView(frame: frame)
                loadingMoreView!.isHidden = true
                restaurantCollectionView.addSubview(loadingMoreView!)

                var insets = restaurantCollectionView.contentInset
                insets.bottom += InfiniteScrollActivityView.defaultHeight
                restaurantCollectionView.contentInset = insets
        }


        func scrollViewDidScroll(_ scrollView: UIScrollView) {
                if !isMoreDataLoading {
                        //Calculate the position of the screen lenght before the botton of the results
                        let scrollViewContentHeight = restaurantCollectionView.contentSize.height
                        let scrollOffsetThreshold = scrollViewContentHeight - restaurantCollectionView.bounds.size.height

                        //whe the user has scrolled past the threshold, start requesting
                        if(scrollView.contentOffset.y > scrollOffsetThreshold && restaurantCollectionView.isDragging){
                                isMoreDataLoading = true
                                //update position of loadingMoreView and start loading indicator
                                let frame = CGRect(x: 0, y: restaurantCollectionView.contentSize.height, width: restaurantCollectionView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                                loadingMoreView?.frame = frame
                                loadingMoreView!.startAnimating()


                                //TODO: Code to load more results
                                //                manager.loadMoreData()
                                //                self.loadMoreData(location: <#T##CLLocationCoordinate2D#>, start: <#T##Int?#>, filter: <#T##String?#>)

                        }

                }
        }
}
