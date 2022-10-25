//
//  MapViewController.swift
//  FoodBook
//
//  Created by Jemiway on 2022/10/25.
//

import UIKit

import MapKit


class MapViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))

        mapView.region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                        latitude: 51.500936, longitude: -0.124636), latitudinalMeters: 1000,
                        longitudinalMeters: 1000)
        
        
        
        mainView.addSubview(mapView)
     //   PlaygroundPage.current.liveView = mapView
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
