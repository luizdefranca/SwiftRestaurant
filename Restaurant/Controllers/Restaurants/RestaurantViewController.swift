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


    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createData()
        setupTitle()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let indexPath = restaurantCollectionView.indexPathsForSelectedItems?.first else {
            print("There is not selected indexPath")
            return
        }
        selectedRestaurant = manager.restaurantItem(at: indexPath)
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
                manager.loadMoreData()
                
            }

        }
    }
}
