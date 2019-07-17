//
//  ExploreViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/8/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController{



    @IBOutlet weak var collectionView: UICollectionView!
    private let manager : ExploreDataManager = ExploreDataManager()
    var selectedCity: LocationItem?
    var headerView : ExploreHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case Segue.restaurantList.rawValue:
            guard selectedCity != nil else {
                showAlert()
                return false
            }
            return true
        default:
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segue.locationList.rawValue:
            showLocationList(segue: segue)
        case Segue.restaurantList.rawValue:
            showRestaurantListing(segue: segue)
        default:
            print("There is not segue")
        }
    }

    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 7
        collectionView.collectionViewLayout = layout
//        layout.headerReferenceSize = CGSize(width: 0, height: 100)
//        layout.sectionHeadersPinToVisibleBounds = true
//        collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }



}

private extension ExploreViewController {
    func showLocationList (segue: UIStoryboardSegue) {
        guard let navController = segue.destination as? UINavigationController, let viewController = navController.topViewController as? LocationViewController
        else { return }
        guard let city = selectedCity else { return  }
        viewController.selectedCity = city
    }

    func showRestaurantListing(segue: UIStoryboardSegue){
        if let vc = segue.destination as? RestaurantViewController,
        let city = selectedCity,
        let index = collectionView.indexPathsForSelectedItems?.first,
            let type = manager.explore(at: index)?.name {
            vc.selectedCity = city
            vc.selectedType = type
        }
    }
    func showAlert() {
        let alertController = UIAlertController(title: "Location needed", message: "Please select a location", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ExploreViewController: UICollectionViewDelegate {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
}

extension ExploreViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        guard let exploreHeaderView = header as? ExploreHeaderView else {
            print("cannot cast to explorerHeaderView\(#file) - \(#line) ")
            return header
        }
        headerView = exploreHeaderView
        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCell", for: indexPath) as! ExploreCollectionViewCell
        cell.exploreItem = manager.explore(at: indexPath)
        return cell
    }

    @IBAction func unwindLocationCancel(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? LocationViewController {
            selectedCity = viewController.selectedCity
            if let location = selectedCity {
                headerView.lblLocation.text = location.city
            }
        }
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Device.isPad {
            let factor = traitCollection.horizontalSizeClass == .compact ? 2 : 3
            let screenRect = collectionView.frame.size.width
            let screenWidth = screenRect - ( 7.0 * CGFloat(factor + 1))
            let cellWidth = screenRect / CGFloat(factor)
            return CGSize(width: cellWidth, height: 195)
        } else {
            let screenRect = collectionView.frame.size.width
            let screenWidth = screenRect - 21
            let cellWidth = screenWidth / 2
            return CGSize(width: cellWidth, height: 195)
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 100)
    }
}
