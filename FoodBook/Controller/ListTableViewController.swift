//
//  ListTableViewController.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/10/23.
//

import UIKit
import Kingfisher
import SQLite3
import MapKit

class ListTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    private var db:OpaquePointer?
    
    var mLocationManager :CLLocationManager!
    var currentLocation:CLLocation!
    
    var searchStr = ""
    var restRow = Restaurant(id: "C3_315080500H_000013", name: "望海巴耐餐廳/咖啡", description: "非常有特色的原住民餐點餐廳，位於台十一線8K區段上，是東海岸行經花蓮大橋進入東海岸國家風景區之後，花蓮遊客中心前，第一家餐飲服務業者；業者於建物外部以當地竹子搭蓋起大門及挑高竹亭，呈顯其自然風格建築形式是其特色。望海巴耐野菜餐廳位於台十一線8K區段上，是東海岸行經花蓮大橋進入東海岸國家風景區之後，花蓮遊客中心前，第一家餐飲服務業者；業者於建物外部以當地竹子搭蓋起大門及挑高竹亭，呈顯其自然風格建築形式是其特色。", add: "花蓮縣974壽豐鄉鹽寮村大橋22號", zipcode: "974", region: "花蓮縣", town: "壽豐鄉", tel: "886-9-37533483", openTime: "11:30 - 20:00", website: "", picture1: "https://www.eastcoast-nsa.gov.tw/image/41530/640x480", picDescribe1: "花蓮無敵海景咖啡餐廳-望海巴耐", picture2: "", picDescribe2: "", picture3: "", picDescribe3: "", px: 121.606110, py: 23.918950, classLevel: "9", map: "", parkingInfo: "",date: "2022-09-06")
    
    var restaurants = [Restaurant]()
    var searchResult = [
        
        Restaurant(id: "C3_315080500H_000013", name: "望海巴耐餐廳/咖啡", description: "非常有特色的原住民餐點餐廳，位於台十一線8K區段上，是東海岸行經花蓮大橋進入東海岸國家風景區之後，花蓮遊客中心前，第一家餐飲服務業者；業者於建物外部以當地竹子搭蓋起大門及挑高竹亭，呈顯其自然風格建築形式是其特色。望海巴耐野菜餐廳位於台十一線8K區段上，是東海岸行經花蓮大橋進入東海岸國家風景區之後，花蓮遊客中心前，第一家餐飲服務業者；業者於建物外部以當地竹子搭蓋起大門及挑高竹亭，呈顯其自然風格建築形式是其特色。", add: "花蓮縣974壽豐鄉鹽寮村大橋22號", zipcode: "974", region: "花蓮縣", town: "壽豐鄉", tel: "886-9-37533483", openTime: "11:30 - 20:00", website: "", picture1: "https://www.eastcoast-nsa.gov.tw/image/41530/640x480", picDescribe1: "花蓮無敵海景咖啡餐廳-望海巴耐", picture2: "", picDescribe2: "", picture3: "", picDescribe3: "", px: 121.606110, py: 23.918950, classLevel: "9", map: "", parkingInfo: "",date: "2022-09-06"),
        Restaurant(id: "C3_315080500H_000016", name: "噶瑪蘭海產店", description: "沒有固定菜單，菜單依照時節隨時更新，主要客群來自附近居民及固定客戶，業者也和附近民宿配合，接待海天、118、沙漠風情、來去海邊等民宿的住房遊客。主要菜色為海鮮料理及噶瑪蘭風味料理，餐廳本身還有供簡易之餐飲服務，可容納約90~120人，這是一間原住民風格濃厚的餐廳。", add: "花蓮縣977豐濱鄉新社村42號", zipcode: "977", region: "花蓮縣", town: "豐濱鄉", tel: "886-3-8711339", openTime: "11:00 - 14:00、17:00 - 19:00", website: "", picture1: "https://www.eastcoast-nsa.gov.tw/image/51996/640x480", picDescribe1: "噶瑪蘭海產店", picture2: "", picDescribe2: "", picture3: "", picDescribe3: "", px: 121.537790, py: 23.653180, classLevel: "9", map: "", parkingInfo: "",date: "2022-09-06"),
        Restaurant(id: "C3_315080500H_000018", name: "口福海鮮餐廳", description: "位處石梯港邊，臨近昕陽餐廳，同時也是東部賞鯨一號的報名處，餐廳主要提供海鮮熱炒料理，室內空間可容納200人以上，淡季客源除了過路觀光客，主要接待當地及附近居民，旺季則以接待遊覽車團體客人為主，是吃飯加賞鯨的好所在。東海岸的石梯坪有湛藍的海景、豐富多樣的海產，口福海鮮餐廳就設在花蓮南區最大的石梯港旁，出產多種迴游魚類、底棲珊瑚礁魚類、東海岸龍蝦，每天早上自家的漁船出海捕撈最新鮮的海產，招牌餐點有生魚片、多種鮮魚料理、東海岸活龍蝦、新鮮鮑魚及各種山、海產料理，不僅品質極佳價錢更是經濟實惠，保證讓您大飽口福，是您旅行東海岸最佳的用餐休息站。", add: "花蓮縣977豐濱鄉石梯港82號", zipcode: "977", region: "花蓮縣", town: "豐濱鄉", tel: "886-3-8781041", openTime: "11:00 - 14:00 、 17:00 - 19:30", website: "", picture1: "https://www.eastcoast-nsa.gov.tw/image/41544/640x480", picDescribe1: "口福海鮮餐廳", picture2: "", picDescribe2: "", picture3: "", picDescribe3: "", px: 121.510850, py: 23.488160, classLevel: "9", map: "", parkingInfo: "",date: "2022-09-06")
        
    ]
    
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet var searchBarOutlet: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取得App的db連線
        db = (UIApplication.shared.delegate as? AppDelegate)?.getDB()
        
//        //準備離線資料集
//        DispatchQueue(label: "data").async {
//            self.getAllRest()
//        }
//        setMapRestData(restData: searchResult)
        
        // 讀取附近的餐廳
        getAround()
        
        // 顯示附近餐廳的城鎮
        regionTextField.text = searchResult[0].town
        
        //初始化下拉更新元件
        let refreshControl = UIRefreshControl()
        //下拉更新元件綁定valueChanged事件觸發handleRefresh函式
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //將下拉更新元件設定給tableView
        self.tableView.refreshControl = refreshControl
        
    }
    
    //由下拉更新元件所觸發的事件
    @objc func handleRefresh()
    {
        //設定下拉更新元件的文字
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")

        //更新表格資料
        self.tableView.reloadData()
        
        //資料更新完成後將表格恢復原位置
        self.tableView.refreshControl?.endRefreshing()
    }
    
    // 開始編輯地區搜尋
    @IBAction func regionTextFieldEditBegin(_ sender: Any) {
        
//        regionTextField.text = ""
    }
    
    // 按下地區搜尋return
    @IBAction func regionTextField(_ sender: Any) {
        
        // 設定搜尋 SQL string
        getSearchRest(searchStr: searchStr)
        
        // 按下地區搜尋return就一定跳到搜尋區域
        let searchRestFirst:CLLocation = CLLocation(latitude: searchResult[0].py, longitude: searchResult[0].px)
        setMapShowArea(position: searchRestFirst)
    }
    
    // 按下附近餐廳按鈕
    @IBAction func aroundButtom(_ sender: Any) {
        
        // 讀取附近的餐廳
        getAround()
        
        // 按下附近餐廳按鈕就一定跳到目前位置
        setMapShowArea(position: currentLocation)
    }
    
    //MARK: - 自定函式
    
    // 顯示指定座標的附近區域
    func setMapShowArea(position:CLLocation) {
     
        // 取得地圖頁的 controller
        let navController = tabBarController?.viewControllers?[1] as? UINavigationController
        let mapViewController = navController?.viewControllers.first as? MapViewController
        
        // 顯示指定的區域
        mapViewController?.updateLocate = position
        mapViewController?.currentLocation = position
    }
    
    
    // 把搜尋餐廳的結果傳到地圖頁
    func setMapRestData(restData:[Restaurant]) {
        
        // 取得地圖頁的 controller
        let navController = tabBarController?.viewControllers?[1] as? UINavigationController
        let mapViewController = navController?.viewControllers.first as? MapViewController
        
        print("restaurants count = \(restData.count)")
        
        // 把搜尋餐廳的結果傳到地圖頁
        mapViewController?.restData = restData
        
        // 把目前位置傳到地圖頁
        mapViewController?.currentLocation = currentLocation
    }

    // 讀取附近的餐廳
    func getAround() {
        
        mLocationManager = CLLocationManager()
        mLocationManager?.requestWhenInUseAuthorization()
        mLocationManager.delegate = self
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation  // kCLLocationAccuracyBest
        
        currentLocation = mLocationManager.location
        
        if let hereForNow = mLocationManager?.location?.coordinate {
            
            print("now locate = \(hereForNow)")
            let lati = String(format: "%.5f", hereForNow.latitude)
            let long = String(format: "%.5f", hereForNow.longitude)
            positionLabel.text = "現在座標 : \(lati) , \(long)"
            
            // 讀取座標點附近的餐廳，最少20家
            getAroundRest(position: hereForNow)
            
        } else {
            print("can't get locate")
        }
    }
    
    // 讀取座標點附近的餐廳，最少20家
    func getAroundRest(position:CLLocationCoordinate2D) {

        var range = 0.0
        repeat {
            searchResult.removeAll()
            range += 0.005
            let pxAdd = String(position.longitude + range)
            let pxDec = String(position.longitude - range)
            let pyAdd = String(position.latitude + range)
            let pyDec = String(position.latitude - range)
            
            let sqlStr = "select name,description,address,region,town,picture1,picDescribe1,px,py,update_date from restaurant where px BETWEEN \(pxDec) AND \(pxAdd) AND py BETWEEN \(pyDec) AND \(pyAdd) AND name like '%\(searchStr)%'"
            
            searchResult = getDataFromTable(sql: sqlStr)
            print("getAroundRest searchResult.count = \(searchResult.count)")
            
        } while searchResult.count < 20 && range < 0.1
        
        // 把搜尋餐廳的結果傳到地圖頁
        setMapRestData(restData: searchResult)
        
        self.tableView.reloadData()
        
    }
    
    // search bar 開始搜尋
    func fetchSearch(name:String) {
        
        // 取得string關鍵字的搜尋結果
        getSearchRest(searchStr: name)
        
        // 按下 search bar return就一定跳到搜尋區域
        let searchRestFirst:CLLocation = CLLocation(latitude: searchResult[0].py, longitude: searchResult[0].px)
        setMapShowArea(position: searchRestFirst)
    }
    
    // 設定搜尋 SQL string
    func getSearchRest(searchStr:String) {
        
        searchResult.removeAll()
        
        let regionStr = regionTextField.text ?? "新北市"
        
        let sqlStr = "select name,description,address,region,town,picture1,picDescribe1,px,py,update_date from restaurant where (region like '%\(regionStr)%' OR town like '%\(regionStr)%') AND name like '%\(searchStr)%'"
        
        // 去資料庫篩選資料
        searchResult = getDataFromTable(sql: sqlStr)
        
        // 資料 update 到 map
        setMapRestData(restData: searchResult)
        
        self.tableView.reloadData()
    }
    
    // 取得所有的餐廳資料
    func getAllRest() {
        
        restaurants.removeAll()
        let sqlStr = "select name,description,address,region,town,picture1,picDescribe1,px,py,update_date from restaurant"
        
        restaurants = getDataFromTable(sql: sqlStr)
    }
    
    
    func getSQLTest() {
        
        var restTests = [Restaurant]()
        let sqlStr = "select name,description,address,region,town,picture1,picDescribe1,px,py,update_date from restaurant"
        
//        let sqlStr = "select * from restaurant"
        
        
        restTests = getDataFromTable(sql: sqlStr)
        
        print(restTests[10])
        
//        for restTest in restTests {
//
//            print("name = \(restTest.name) ， date = \(restTest.date)")
//
//        }
    }
    
    
    //查詢資料庫
    func getDataFromTable(sql:String) -> [Restaurant]
    {
        var restAll = [Restaurant]()
        
        //將SQL指令轉換成C語言的字元陣列
        let cSql = sql.cString(using: .utf8)!
        
        //宣告儲存查詢結果的指標（連線資料集）
        var statement:OpaquePointer?
        
        //準備查詢（第三個參數：若為正數則限定SQL指令的長度，若為負數則不限SQL指令的長度。第四個參數和第六個參數為預留參數，目前沒有作用。第五個參數會儲存SQL指令的執行結果。）
        if sqlite3_prepare_v3(db!, cSql, -1, 0, &statement, nil) == SQLITE_OK
        {
            print("資料庫查詢指令執行成功")
            
            //往下讀取一筆『連線資料集』中的資料
            while sqlite3_step(statement!) == SQLITE_ROW
            {
                //讀取當筆資料的每一欄
            
                if let name = sqlite3_column_text(statement!, 0) {
                    let strName = String(cString: name)
                    restRow.name = strName
                }
                
                if let description = sqlite3_column_text(statement!, 1) {
                    let strDescription = String(cString: description)
                    restRow.description = strDescription
                }
                
                if let add = sqlite3_column_text(statement!, 2) {
                    let strAdd = String(cString: add)
                    restRow.add = strAdd
                }
                
                if let region = sqlite3_column_text(statement!, 3) {
                    let strRegion = String(cString: region)
                    restRow.region = strRegion
                }
                
                
                if let town = sqlite3_column_text(statement!, 4) {
                    let strTown = String(cString: town)
                    restRow.town = strTown
                }
                
                
                if let picture1 = sqlite3_column_text(statement!, 5) {
                    let strPicture1 = String(cString: picture1)
                    restRow.picture1 = strPicture1
                }
                
                if let picDescribe1 = sqlite3_column_text(statement!, 6) {
                    let strPicDescribe1 = String(cString: picDescribe1)
                    restRow.picDescribe1 = strPicDescribe1
                }
                
                let px = sqlite3_column_double(statement!, 7)
                restRow.px = px
                
                let py = sqlite3_column_double(statement!, 8)
                restRow.py = py
                
                if let update_date = sqlite3_column_text(statement!, 9) {
                    let strUpdate = String(cString: update_date)
                    restRow.date = strUpdate
                }
                
                // print(restRow)
                
                restAll.append(restRow)
            }
            //關閉連線資料集
            if statement != nil
            {
                sqlite3_finalize(statement!)
            }
        }
        else
        {
            print("資料庫查詢指令執行失敗")
        }
        
        return restAll
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailTableViewController? {
        
        let controller = DetailTableViewController(coder: coder)
        
        if let row = tableView.indexPathForSelectedRow?.row {
            
            controller?.rest = searchResult[row]
            
        }
        return controller
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as! ListTableViewCell
        
        let rest = searchResult[indexPath.row]
        
        if let url = URL(string: rest.picture1) {
            cell.cellImageView.kf.setImage(with: url)
            
        } else {
            let url = Bundle.main.url(forResource: "picture1", withExtension: "jpg")
            cell.cellImageView.kf.setImage(with: url)
        }
        
        cell.cellNameLabel.text = rest.name
        cell.cellRegionLabel.text = "\(rest.region) \(rest.town)"
        return cell
    }
}


extension ListTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("SearchButtonClicked did end")
        searchStr = searchBar.text ?? ""
        fetchSearch(name: searchStr)
        view.endEditing(true)
    }
}
