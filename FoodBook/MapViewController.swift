//
//  MapViewController.swift
//  FoodBook
//
//  Created by Jemiway on 2022/10/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var mLocationManager :CLLocationManager!
    var mMapView :MKMapView!
    
    
    var test = 123
    
    var restData:[Restaurant]!
    
    var myLocate = [
        CLLocation(latitude: 25.034012, longitude: 121.56446),
        CLLocation(latitude: 25.034012, longitude: 121.56446)
    ]
    
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let restData {
//            print("count = \(restData.count)")
//        } else {
//            print("no data")
//        }
//        print("restaurant = \(restaurants.count)")
        
        print("map", test)
        
        showMap()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    

    
    func showMap() {
        
        // 地圖設置
        mMapView = MKMapView()
        mMapView.delegate = self
        mMapView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(mMapView)

        // 經緯度控制
        mLocationManager = CLLocationManager()
        mLocationManager?.requestWhenInUseAuthorization()
        mLocationManager.delegate = self
        
        // 取得自身定位位置的精確度
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //授權同意後取得使用者位置後指派給hereForNow
        if let _ = mLocationManager?.location?.coordinate {
            
            if let myCL = mLocationManager.location {
                
                myLocate.insert(myCL, at: 0)
                
                locationManager(mLocationManager, didUpdateLocations: myLocate)
                
                print("------ ok ")
            } else {
                print("------ ng ")
            }
        } else {
            print("no no no ")
        }

    }
    
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //取得當下座標
        let currentLocation :CLLocation = locations[0] as CLLocation
        
        //總縮放範圍
        let range:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
     
        //自身
        let myLocation = currentLocation.coordinate
        let appearRegion:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: range)


//        objectAnnotation.coordinate = CLLocationCoordinate2D(latitude: 24.930068, longitude: 121.171491)
//        objectAnnotation.coordinate = CLLocation(latitude: 24.930068, longitude: 121.171491).coordinate
        
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = locations[0].coordinate
        objectAnnotation.title = "目前位置"
        objectAnnotation.subtitle = "現在"
        mMapView.addAnnotation(objectAnnotation)
        
        mMapView.tintColor = .brown
        
        for index in restData {
            
            objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = CLLocation(latitude: index.py, longitude: index.px).coordinate
            objectAnnotation.title = index.name
            objectAnnotation.subtitle = index.add
            mMapView.addAnnotation(objectAnnotation)
            
        }

       
        mMapView.setRegion(appearRegion, animated: true)
        
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
