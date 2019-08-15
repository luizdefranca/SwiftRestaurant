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
        var selectedRestaurant: Restaurant?
        var restaurants = [Restaurant]()


        override func viewDidLoad() {
                super.viewDidLoad()

                initial()
                print("#################\(#function)###########")
                dump(restaurants)
        }

        
        override func viewWillAppear(_ animated: Bool) {
                NotificationCenter.default.addObserver(self, selector: #selector(updateRestaurants(_ :)), name: NSNotification.Name("code.luizramos.Restaurant.updateRestaurants"), object: nil)
                print("#################\(#function)###########")
                dump(restaurants)
        }

        func addMap(_ annotations: [Restaurant]) {
                mapView.setRegion(manager.currentRegion(latDelta: 0.5, longDelta: 0.5), animated: true)
                mapView.addAnnotations(manager.annotations)
                if let center = manager.annotations.first {
                        mapView.setCenter(center.coordinate, animated: true)
                }
        }

        @objc func updateRestaurants(_ notification: NSNotification){
                guard let updatedRestaurants = notification.object as? [Restaurant] else {
                        return
                }
                self.restaurants = updatedRestaurants
//                dump(updatedRestaurants)


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
                selectedRestaurant = annotation as? Restaurant
                self.performSegue(withIdentifier: Segue.showDetail.rawValue, sender: self)
        }
}
