//
//  RestaurantDetailViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/11/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UITableViewController {


    var selectedRestaurant: RestaurantItem?
    var startLoading: Int = 0
    var loadingRestaurant = false
    @IBOutlet weak var btnHeart: UIBarButtonItem!

    //Cell One
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblCuisine: UILabel!
    @IBOutlet weak var lblHeaderAddress: UILabel!

    //Cell two
    @IBOutlet weak var lblTableDetails: UILabel!

    //cell three
    @IBOutlet weak var lblOverallRating: UILabel!

    //cell eight
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var ratingView: RatingsView!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("############################## \(self) #######################")
        dump(selectedRestaurant as Any)

        btnHeart.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 26.0)!],
                                          for: .normal)
//        setupAll()
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        setupAll()
    }

    func setupAll(){
        setupLabels()
        setupMap()
        setupRating()
    }
}

private extension RestaurantDetailViewController {
    func setupLabels() {
        guard let restaurant = selectedRestaurant else {return}
        if let name = restaurant.name {
            lblName.text = name
            title = name
        }

        if let cuisine = restaurant.subtitle {
            lblCuisine.text = cuisine
        }

        if let address = restaurant.address {
            lblAddress.text = address
            lblHeaderAddress.text = address
        }

        lblTableDetails.text = "Table for 7, tonight at 10:00 PM"
    }

    func setupMap() {
        guard let annotation = selectedRestaurant,
            let lat = annotation.lat,
            let long = annotation.long
            else {return}
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        takeSnapShot(with: location)
    }

    func takeSnapShot(with location: CLLocationCoordinate2D) {
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        var loc = location
        let polyLine = MKPolyline(coordinates: &loc, count: 1)
        let region = MKCoordinateRegion(polyLine.boundingMapRect)
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: view.frame.width, height: 208)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        let snapshotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapshotter.start() { snapshot, error in
            guard let snapshot = snapshot else { return}
            UIGraphicsBeginImageContextWithOptions(mapSnapshotOptions.size, true, 0)
            snapshot.image.draw(at: .zero)
            let identifier = "custompin"
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.image = UIImage(named: "custom-annotation")
            let pinImage = pinView.image
            var point = snapshot.point(for: location)

            let rect = self.imgMap.bounds

            if rect.contains(point) {
                let pinCenterOffset = pinView.centerOffset
                point.x -= pinView.bounds.size.width / 2
                point.y -= pinView.bounds.size.height / 2
                point.x += pinCenterOffset.x
                point.y += pinCenterOffset.y
                pinImage?.draw(at: point)
            }
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    self.imgMap.image = image
                }
            }
        }

        
    }

    func setupRating() {
        ratingView.rating = 3.5
        ratingView.isEnabled = true
    }

    @IBAction func unwindReviewCancel(segue: UIStoryboard) { }
}
