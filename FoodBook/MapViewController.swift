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
    var currentLocation:CLLocation!
    
    var mMapView :MKMapView!
    var restData:[Restaurant]!
    var rest:Restaurant!
    
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
    
    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let listViewController = navController?.viewControllers.first as? ListTableViewController
        
        let touchPoint = sender.location(in: mMapView)     // touch的位置轉成座標
        let touch:CLLocationCoordinate2D = mMapView.convert(touchPoint, toCoordinateFrom: mMapView)
        
        listViewController?.getAroundRest(position: touch)
        
        setAnnotation()
    }
    
    
    func showMap() {
        
        // 地圖設置
        mMapView = MKMapView()
        mMapView.delegate = self
        mMapView.frame = CGRect.init(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height-80)
        self.view.addSubview(mMapView)

        // 經緯度控制
        mLocationManager = CLLocationManager()
        mLocationManager?.requestWhenInUseAuthorization()
        mLocationManager.delegate = self
        mLocationManager.allowsBackgroundLocationUpdates = true  //允許背景更新位置(需配合capabilities的Background的Location設定)
        mLocationManager.pausesLocationUpdatesAutomatically = false  //不要自動暫停位置更新
        
        // 取得自身定位位置的精確度
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 讓定位管理員開始定位
        mLocationManager.startUpdatingLocation()

        setCurrentLocate()
        
    }
    
    
    func setAnnotation() {
        
        // 取得目前所有大頭針
        let annotation = mMapView.annotations
        //移除有所的大頭針
        mMapView.removeAnnotations(annotation)
        
        // 放上新的大頭針
        var objectAnnotation = MKPointAnnotation()
        for index in restData {
            objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = CLLocation(latitude: index.py, longitude: index.px).coordinate
            objectAnnotation.title = index.name
            objectAnnotation.subtitle = index.add
            mMapView.tintColor = .yellow
            mMapView.addAnnotation(objectAnnotation)
        }
    }
    
    func setCurrentLocate() {
        
        //製作地圖區域框選在目前位置附近
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        //將地圖調整顯示區域在目前位置附近
        mMapView.setRegion(region, animated: false)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //取得當下座標
        currentLocation = locations.first
        // 顯示目前位置
        mMapView.showsUserLocation = true
        
        setAnnotation()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let touchPointX = view.annotation?.coordinate.longitude ?? 0.0
        let touchPointY = view.annotation?.coordinate.latitude ?? 0.0
        
        for index in restData {
            if index.px == touchPointX && index.py == touchPointY {
                rest = index
                break
            } else {
                rest = restData[0]
            }
        }
        performSegue(withIdentifier: "showMapSegue", sender: nil)
    }
    

    @IBSegueAction func showMapDetail(_ coder: NSCoder, sender: Any?) -> DetailTableViewController? {
        
        let controller = DetailTableViewController(coder: coder)
        
        controller?.rest = rest
        
        return controller
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
