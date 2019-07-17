//
//  MapViewController.swift
//  Restaurant
//
//  Created by Luiz on 7/10/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    let manager = MapDataManager()
    var selectedRestaurant: RestaurantItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        initial()
    }



    func addMap(_ annotations: [RestaurantItem]) {
        mapView.setRegion(manager.currentRegion(latDelta: 0.5, longDelta: 0.5), animated: true)
        mapView.addAnnotations(manager.annotations)
        if let center = manager.annotations.first {
        mapView.setCenter(center.coordinate, animated: true)
        }
    }


    func initial() {
        manager.fetch { (annotations) in
            addMap(annotations)
        }

        mapView.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.showDetail.rawValue:

            if let nc = segue.destination as? UINavigationController, let vc = nc.topViewController as? RestaurantDetailViewController, let restaurant = selectedRestaurant {
                vc.selectedRestaurant = restaurant
                dump(selectedRestaurant)
                print(selectedRestaurant)
            }
        default:
            print("Need to add a segue")
        }
    }

}

extension MapViewController : MKMapViewDelegate {

    //This method grabs the annotations before they are placed and replace the default pins with custom pins
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "custompin"

        //Check if the annotations is not hte user location
        guard !annotation.isKind(of: MKAnnotation.self) else {return nil}
        var annotationView: MKAnnotationView?

        
        if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = customAnnotationView
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av

        }

        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "custom-annotation")
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = mapView.selectedAnnotations.first else {return}
        selectedRestaurant = annotation as? RestaurantItem
        self.performSegue(withIdentifier: Segue.showDetail.rawValue, sender: self)
    }
}
