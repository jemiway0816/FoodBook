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
    var updateLocate:CLLocation!
    
    var mMapView :MKMapView!
    var restData:[Restaurant]!
    var rest:Restaurant!
    
    var myLocate = [
        CLLocation(latitude: 25.034012, longitude: 121.56446)
    ]
    
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 第一次切換到地圖頁，地圖顯示區域設定在目前位置
        updateLocate = currentLocation
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // 重新顯示地圖
        showMap()
    }
    
    // 長按螢幕兩秒執行附近餐廳搜尋
    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        // 取得餐廳列表頁的 controller
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let listViewController = navController?.viewControllers.first as? ListTableViewController
        
        // touch的位置轉成座標
        let touchPoint = sender.location(in: mMapView)
        let touch:CLLocationCoordinate2D = mMapView.convert(touchPoint, toCoordinateFrom: mMapView)
        
        listViewController?.getAroundRest(position: touch)
        
        // 更新餐廳列表頁裡餐廳所在的城鎮
        listViewController?.regionTextField.text = listViewController?.searchResult[0].town
        listViewController?.searchBarOutlet.text = ""
        
        // 儲存目前餐廳座標，由Detail返回時能正確顯示目前餐廳區域
        updateLocate = CLLocation(latitude: touch.latitude, longitude: touch.longitude)
        
        // 顯示大頭針
        setAnnotation()
        
    }
    
    // 重新顯示地圖
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
        
        //允許背景更新位置(需配合capabilities的Background的Location設定)
        mLocationManager.allowsBackgroundLocationUpdates = true
        
        //不要自動暫停位置更新
        mLocationManager.pausesLocationUpdatesAutomatically = false
        
        // 取得自身定位位置的精確度
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 讓定位管理員開始定位
        mLocationManager.startUpdatingLocation()

        // 設定地圖顯示區域
        setCurrentLocate(setPosition: updateLocate)
        
        // 顯示大頭針
        setAnnotation()
        
    }
    
    // 顯示大頭針
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
    
    // 設定地圖顯示區域
    func setCurrentLocate(setPosition:CLLocation) {
        
        //製作地圖區域框
        let region = MKCoordinateRegion(center: setPosition.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        
        //將地圖調整顯示區域
        mMapView.setRegion(region, animated: false)
    }
    
    func getNowPosition() -> (String,String) {
        
        let lati = String(format: "%.5f", currentLocation.coordinate.latitude)
        let long = String(format: "%.5f", currentLocation.coordinate.longitude)
        
        return (lati,long)
    }
    
    // 持續更新目前位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //取得當下座標
        currentLocation = locations.first
        
        // 顯示目前位置
        mMapView.showsUserLocation = true
    }
    
    // 按下大頭針
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let touchPointX = view.annotation?.coordinate.longitude ?? 0.0
        let touchPointY = view.annotation?.coordinate.latitude ?? 0.0
        
        // 拿到大頭針座標的餐廳資訊
        for index in restData {
            if index.px == touchPointX && index.py == touchPointY {
                rest = index
                break
            } else {
                rest = restData[0]
            }
        }
        
        // 儲存目前餐廳座標，由Detail返回時能正確顯示目前餐廳區域
        updateLocate = CLLocation(latitude: touchPointY, longitude: touchPointX)
        
        // 跳到 Detail 頁
        performSegue(withIdentifier: "showMapSegue", sender: nil)
    }
    
    
    // segue 的 action
    @IBSegueAction func showMapDetail(_ coder: NSCoder, sender: Any?) -> DetailTableViewController? {
        
        let controller = DetailTableViewController(coder: coder)
        
        // 將大頭針餐廳的資訊傳到 Detail 頁
        controller?.rest = rest
        
        return controller
    }
}
