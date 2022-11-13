//
//  UpdateTableViewController.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/10/25.
//
//  https://data.gov.tw/dataset/7779
//
import UIKit
import SQLite3

class UpdateTableViewController: UITableViewController {

    //紀錄由C語言所開啟的資料庫指標
    private var db:OpaquePointer?
    
    var restNews = [Info]()
    
    var id = ""
    var name = ""
    var descriptionStr = ""
    var addStr = ""
    var zipcode = ""
    var region = ""
    var town = ""
    var tel = ""
    var opentime = ""
    var website = ""
    var picture1 = ""
    var picDescribe1 = ""
    var picture2 = ""
    var picDescribe2 = ""
    var picture3 = ""
    var picDescribe3 = ""
    var px = 0.0
    var py = 0.0
    var classStr = ""
    var map = ""
    var parkinginfo = ""
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //取得App的db連線
        db = (UIApplication.shared.delegate as? AppDelegate)?.getDB()
    }

    // MARK: - Table view data source
    
    @IBAction func updateButton(_ sender: Any) {
        
        update()
   
//        showTest()
        
    }
    
    @IBAction func showTestButton(_ sender: Any) {
        
        showTest()
    }
    // 從網路取得最新餐廳資料到 restNews 陣列
    func update() {
        
        let url = URL(string: "https://gis.taiwan.net.tw/XMLReleaseALL_public/restaurant_C_f.json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let restOrg = try decoder.decode(REST.self, from: data)
                    
                    self.restNews = restOrg.xmlHead.infos.info
                    
                    DispatchQueue.main.async {
                        self.preperUpdateDB()
                    }
//                    print(self.restNews[0])
                    
                } catch  {
                    print(error)
                }
            }

        }.resume()

    }
    
    func showTest() {
        
        // 取得餐廳列表頁的 controller
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let listViewController = navController?.viewControllers.first as? ListTableViewController
        
        listViewController?.getSQLTest()
    }
    
    
    
    func preperUpdateDB() {
        
        let day = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        let today:String = dateFormatter.string(from: day)
        print("today = \(today)")
        
        // 刪除原來db的餐廳
        
        // 增加新的餐廳到db
        
//        for restNew in restNews {
//        }
        
        // 先試試看新增一筆
        
        
        var restNew = restNews[0]
        
        id = restNew.id                             // 1
        name = restNew.name                         // 2
        descriptionStr = restNew.infoDescription    // 3
        addStr = restNew.add                        // 4
        zipcode = restNew.zipcode!                  // 5
        region = restNew.region!.rawValue           // 6
        town = restNew.town!                        // 7
        tel = restNew.tel                           // 8
        opentime = restNew.opentime                 // 9
        website = restNew.website ?? ""             // 10
        picture1 = restNew.picture1                 // 11
        picDescribe1 = restNew.picdescribe1         // 12
        picture2 = restNew.picture2 ?? ""           // 13
        picDescribe2 = restNew.picdescribe2 ?? ""   // 14
        picture3 = restNew.picture3 ?? ""           // 15
        picDescribe3 = restNew.picdescribe3 ?? ""   // 16
        px = restNew.px                             // 17
        py = restNew.py                             // 18
        classStr = restNew.infoClass!               // 19
        map = restNew.map ?? ""                     // 20
        parkinginfo = restNew.parkinginfo ?? ""     // 21
        date = today                                // 22
        
        // INSERT INTO Store_Information (Store_Name, Sales, Txn_Date) VALUES ('Los Angeles', 900, 'Jan-10-1999');
        
//        let restUpdate = Restaurant(id: id, name: name, description: descriptionStr, add: addStr, zipcode: zipcode, region: region, town: town, tel: tel, openTime: opentime, website: website, picture1: picture1, picDescribe1: picDescribe1, picture2: picture2, picDescribe2: picDescribe2, picture3: picture3, picDescribe3: picDescribe3, px: px, py: py, classLevel: classStr, map: map, parkingInfo: parkinginfo,date:date)
        
        let sqlStr = "insert into restaurant (id, name, description, address, zipcode, region, town, tel, opentime, website, picture1, picdescribe1, picture2, picdescribe2, picture3, picdescribe3, px, py, class, map, parkinginfo, update_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
        updateDB(sqlStr: sqlStr)
        
        // update 日期
        // update restaurant set date='2022-09-06'
        
        
    }
    
    
    
    func updateDB(sqlStr:String) {
        
        //Step1.新增資料庫資料
        //準備新增用的sql指令
//        let sql = "insert into student(no,name,gender,picture,phone,address,email,myclass) values(?,?,?,?,?,?,?,?)"
        
        let sql = sqlStr
        
        //將SQL指令轉換成C語言的字元陣列
        let cSql = sql.cString(using: .utf8)!
        //宣告儲存異動結果的指標
        var statement:OpaquePointer?
        
        //準備異動資料（第三個參數：若為正數則限定SQL指令的長度，若為負數則不限SQL指令的長度。第四個參數和第六個參數為預留參數，目前沒有作用。第五個參數會儲存SQL指令的執行結果。）
        if sqlite3_prepare_v3(db!, cSql, -1, 0, &statement, nil) == SQLITE_OK
        {
            //準備要綁定到第 1
            let idSql = id.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第一個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 1, idSql, -1, nil)
            
            //準備要綁定到第 2
            let nameSql = name.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第二個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 2, nameSql, -1, nil)
     
//            //準備要綁定到第三個問號的資料
//            let gender = description.selectedRow(inComponent: 0)
//            //將資料綁定到update指令<參數一>的第三個問號<參數二>，指定介面上的資料<參數三>。
//            sqlite3_bind_int(statement, 3, Int32(gender))
            
            //準備要綁定到第 3
            let descriptionSql = descriptionStr.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第三個問號<參數二>，指定介面上的資料<參數三>。
            sqlite3_bind_text(statement, 3, descriptionSql, -1, nil)
            
//            //準備要綁定到第四個問號的資料
//            let imgData = imgPicture.image!.jpegData(compressionQuality: 0.7)!
//            //將資料綁定到update指令<參數一>的第四個問號<參數二>，指定介面上圖檔的位元資料<參數三>，以及檔案長度<參數四>，參數五為預留參數。
//            sqlite3_bind_blob(statement, 4, (imgData as NSData).bytes, Int32(imgData.count), nil)
//
            //準備要綁定到第 4
            let addStrSql = addStr.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第四個問號<參數二>，指定介面上圖檔的位元資料<參數三>，以及檔案長度<參數四>，參數五為預留參數。
            sqlite3_bind_text(statement, 4, addStrSql, -1, nil)
            
            //準備要綁定到第 5
            let zipcodeSql = zipcode.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第五個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 5, zipcodeSql, -1, nil)
            
            //準備要綁定到第 6
            let regionSql = region.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第六個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 6, regionSql, -1, nil)
            
            //準備要綁定到第 7
            let townStr = town.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第七個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 7, townStr, -1, nil)
            
            //準備要綁定到第 8
            let telSql = tel.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 8, telSql, -1, nil)
            
            //準備要綁定到第 9
            let opentimeSql = opentime.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 9, opentimeSql, -1, nil)
            
            //準備要綁定到第 10
            let websiteSql = website.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 10, websiteSql, -1, nil)
        
            //準備要綁定到第 11
            let picture1Sql = picture1.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 11, picture1Sql, -1, nil)
            
            //準備要綁定到第 12
            let picDescribe1Sql = picDescribe1.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 12, picDescribe1Sql, -1, nil)
        
            //準備要綁定到第 13
            let picture2Sql = picture2.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 13, picture2Sql, -1, nil)
            
            //準備要綁定到第 14
            let picDescribe2Sql = picDescribe2.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 14, picDescribe2Sql, -1, nil)
            
            //準備要綁定到第 15
            let picture3Sql = picture3.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 15, picture3Sql, -1, nil)
            
            //準備要綁定到第 16
            let picDescribe3Sql = picDescribe3.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 16, picDescribe3Sql, -1, nil)
            
            //準備要綁定到第 17
            sqlite3_bind_double(statement, 17, px)
            
            //準備要綁定到第 18
            sqlite3_bind_double(statement, 18, px)
            
            //準備要綁定到第 19
            let classStrSql = classStr.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 19, classStrSql, -1, nil)
            
            //準備要綁定到第 20
            let mapSql = map.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 20, mapSql, -1, nil)
            
            //準備要綁定到第 21
            let parkinginfoSql = parkinginfo.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 21, parkinginfoSql, -1, nil)
            
            //準備要綁定到第 22
            let dateSql = date.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 22, dateSql, -1, nil)
            
            //執行資料庫異動，如果執行不成功
            if sqlite3_step(statement!) != SQLITE_DONE
            {
                //產生提示視窗
                let alert = UIAlertController(title: "資料處理", message: "資料新增失敗", preferredStyle: .alert)
                //產生提示視窗內用的按鈕
                let okAction = UIAlertAction(title: "確定", style: .destructive)
                //將按鈕加入提示視窗
                alert.addAction(okAction)
                //顯示提示視窗
                self.present(alert, animated: true)
                //關閉連線資料集
                if statement != nil
                {
                    sqlite3_finalize(statement!)
                }
                //直接離開
                return
            }
            else
            {
                print("新增成功")
                //關閉連線資料集
                if statement != nil
                {
                    sqlite3_finalize(statement!)
                }
            }
        }
        
    }
    


}
