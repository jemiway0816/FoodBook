
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
    var sqlHeaderStr = "select name,description,address,region,town,picture1,picdescribe1,px,py,update_date,tel,opentime,website from restaurant"
    var favRests = [Restaurant]()
    var restaurants = [Restaurant]()
    var searchResult = [Restaurant]()
    
    @IBOutlet weak var aroundButtonOutlet: UIButton!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet var searchBarOutlet: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取得App的db連線
        db = (UIApplication.shared.delegate as? AppDelegate)?.getDB()
        
        // 讀取附近的餐廳
        getAround()
        
        // 顯示附近餐廳的城鎮
        regionTextField.text = searchResult[0].town
        aroundButtonOutlet.layer.cornerRadius = 5
        
        // 讀取我的最愛餐廳存檔
        if let readFavRests = Restaurant.readFavFromFile() {
            self.favRests = readFavRests
            
//            for fav in favRests {
//                print("======>> \(fav.name)")
//            }
        }
        
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
        
        regionTextField.text = ""
    }
    
    // 按下地區搜尋return
    @IBAction func regionTextField(_ sender: Any) {
        
        // 設定搜尋 SQL string
        getSearchRest(searchStr: searchStr)
        
        if searchResult.count != 0 {
            
            // 按下地區搜尋return就跳到搜尋區域
            let searchRestFirst:CLLocation = CLLocation(latitude: searchResult[0].py, longitude: searchResult[0].px)
            setMapShowArea(position: searchRestFirst)
        }
    }
    
    // 按下附近餐廳按鈕
    @IBAction func aroundButtom(_ sender: Any) {
        
        // 讀取附近的餐廳
        getAround()
        
        // 按下附近餐廳按鈕就跳到目前位置
        setMapShowArea(position: currentLocation)
    }
    
    //MARK: - 自定函式
    
    func showAlert(_ titleStr:String , _ messageStr:String) {
        
        //產生提示視窗
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
        //產生提示視窗內用的按鈕
        let okAction = UIAlertAction(title: "確定", style: .default)
        //將按鈕加入提示視窗
        alert.addAction(okAction)
        //顯示提示視窗
        self.present(alert, animated: true)
    }
    
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
        
//        print("restaurants count = \(restData.count)")
        
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
            
//            print("now locate = \(hereForNow)")
//            let lati = String(format: "%.5f", hereForNow.latitude)
//            let long = String(format: "%.5f", hereForNow.longitude)

            // 讀取座標點附近的餐廳，最少20家
            getAroundRest(position: hereForNow)
            
        } else {
            
            // 無法定位
//            print("can't get locate")
            
            // 使用預設值
            let hereForNow:CLLocation = CLLocation(latitude: 24.98, longitude: 121.45)
            currentLocation = hereForNow
            getAroundRest(position: hereForNow.coordinate)
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
            
//            let sqlStr = "select name,description,address,region,town,picture1,picDescribe1,px,py,update_date from restaurant where px BETWEEN \(pxDec) AND \(pxAdd) AND py BETWEEN \(pyDec) AND \(pyAdd) AND name like '%\(searchStr)%'"
            
            let sqlStr = sqlHeaderStr + " where px BETWEEN \(pxDec) AND \(pxAdd) AND py BETWEEN \(pyDec) AND \(pyAdd) AND name like '%\(searchStr)%'"
            
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
        
        if searchResult.count != 0 {
            
            // 按下 search bar return就跳到搜尋區域
            let searchRestFirst:CLLocation = CLLocation(latitude: searchResult[0].py, longitude: searchResult[0].px)
            setMapShowArea(position: searchRestFirst)
        }
    }
    
    // 設定搜尋 SQL string
    func getSearchRest(searchStr:String) {
        
        searchResult.removeAll()
        
        let regionStr = regionTextField.text ?? "新北市"
        
        let sqlStr = sqlHeaderStr + " where (region like '%\(regionStr)%' OR town like '%\(regionStr)%') AND name like '%\(searchStr)%'"
        
        // 去資料庫篩選資料
        searchResult = getDataFromTable(sql: sqlStr)
        
        // 資料 update 到 map
        setMapRestData(restData: searchResult)
        
        self.tableView.reloadData()
    }
    
    // 取得所有的餐廳資料
    func getAllRest() {
        
        restaurants.removeAll()
        let sqlStr = sqlHeaderStr
        
        restaurants = getDataFromTable(sql: sqlStr)
    }
    
    
    func getLastUpdateDate() -> String {
        
        var restTests = [Restaurant]()
        let sqlStr = sqlHeaderStr + " limit 5 "

        restTests = getDataFromTable(sql: sqlStr)
        
        var returnValue = ""
        if restTests.count != 0 {
            returnValue = restTests[0].date
        }
        return returnValue
    }
    
    func getSQLTest() {
        
//        var restTests = [Restaurant]()
//
//        let sqlStr = sqlHeaderStr + " where update_date == '2022-11-14' "
//
//        restTests = getDataFromTable(sql: sqlStr)
//
//        var index = 1
//        for restTest in restTests {
//
//            print("\(index) name = \(restTest.name) ， date = \(restTest.date)")
//            index += 1
//        }
        
        var regionList:[String] = []
        var townList:[String] = []
        var regionTownList:[String] = []
        
        getAllRest()
        
        for rest in restaurants {
            
            if regionList.contains(rest.region) == false {
                regionList.append(rest.region)
            }
            
            if townList.contains(rest.town) == false {
                townList.append(rest.town)
                regionTownList.append(rest.region + rest.town)
            }
        }
        
        let regionSort = regionList.sorted()
        print("regionList = \(regionSort)")
        print("townList = \(regionTownList)")
        
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
                
                if let tel = sqlite3_column_text(statement!, 10) {
                    let strTel = String(cString: tel)
                    restRow.tel = strTel
                }
                
                if let opentime = sqlite3_column_text(statement!, 11) {
                    let strOpentime = String(cString: opentime)
                    restRow.openTime = strOpentime
                }
                
                if let website = sqlite3_column_text(statement!, 12) {
                    let strWebsite = String(cString: website)
                    restRow.website = strWebsite
                }
                
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
        
        controller?.favButtonEnable = true
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
        cell.cellImageView.layer.cornerRadius = 8
    
        cell.cellNameLabel.text = rest.name
        cell.cellRegionLabel.text = "\(rest.region) \(rest.town)"
        
        cell.cellWebsiteLabel.clipsToBounds = true
        cell.cellWebsiteLabel.backgroundColor = .orange
        cell.cellWebsiteLabel.layer.cornerRadius = 5
        
        if rest.website == "" {
            cell.cellWebsiteLabel.isHidden = true
        } else {
            cell.cellWebsiteLabel.isHidden = false
        }
        
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
