//
//  MapViewController.swift
//  FoodBook
//
//  Created by Jemiway on 2022/10/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var mLocationManager :CLLocationManager!
    var mMapView :MKMapView!

    var restData:[Restaurant]!
    
    var myLocate = [
        CLLocation(latitude: 25.034012, longitude: 121.56446)
    ]
    
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        
        print("restData.count = \(restData.count)")
        showMap()
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
        
        let searchLocate = CLLocation(latitude: restData[0].py, longitude: restData[0].px)
        
        //授權同意後取得使用者位置後指派給 hereForNow
        if let hereForNow = mLocationManager?.location?.coordinate {
            
            print("hereForNow => \(hereForNow)")   // hereForNow => CLLocationCoordinate2D
            
            
            if let myCL = mLocationManager.location {
                
                myLocate.insert(myCL, at: 0)
                myLocate.insert(searchLocate, at: 0)
                
                locationManager(mLocationManager, didUpdateLocations: myLocate)
                
            }
        } else {
            print("can't get hereForNow")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //取得當下座標
        let currentLocation :CLLocation = locations[0] as CLLocation

        print("now locate = \(currentLocation)")
        
        //總縮放範圍
        let range:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)

        //顯示地圖
        let myLocation = currentLocation.coordinate
        let appearRegion:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: range)

        // 放上大頭針
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = locations[0].coordinate
        objectAnnotation.title = "目前位置"
        objectAnnotation.subtitle = "現在"
        mMapView.tintColor = .brown
        mMapView.addAnnotation(objectAnnotation)

        for index in restData {
            objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = CLLocation(latitude: index.py, longitude: index.px).coordinate
            objectAnnotation.title = index.name
            objectAnnotation.subtitle = index.add
            mMapView.tintColor = .yellow
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
