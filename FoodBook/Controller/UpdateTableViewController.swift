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
    var description_str = ""
    var add_str = ""
    var zipcode = ""
    var region = ""
    var town = ""
    var tel = ""
    var opentime = ""
    var website = ""
    var picture1 = ""
    var pic_describe1 = ""
    var picture2 = ""
    var pic_describe2 = ""
    var picture3 = ""
    var pic_describe3 = ""
    var px = 0.0
    var py = 0.0
    var class_str = ""
    var map = ""
    var parking_info = ""
    var update_date = ""
    
    
    @IBOutlet var updateMsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //取得App的db連線
        db = (UIApplication.shared.delegate as? AppDelegate)?.getDB()
        
        // 取得餐廳列表頁的 controller
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let listViewController = navController?.viewControllers.first as? ListTableViewController
        
        updateMsgLabel.text = listViewController?.getLastUpdateDate()

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
    
    
    func deleteData() {
        
        let deleteString = "DELETE FROM restaurant "
        var deleteStatement: OpaquePointer?
        //第一步
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            //第二步
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("删除成功")
            }
        } else {
            print("資料庫無法連結")
        }
        //第三步
        sqlite3_finalize(deleteStatement)
    }
    
    
    func preperUpdateDB() {
        
        // 刪除所有資料
        deleteData()
        
        let day = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        let today:String = dateFormatter.string(from: day)
        print("today = \(today)")
        updateMsgLabel.text = today
        
        var index = 1
        
        for restNew in restNews {
            
            id = restNew.id                              // 1
            name = restNew.name                          // 2
            description_str = restNew.infoDescription    // 3
            add_str = restNew.add                        // 4
            zipcode = restNew.zipcode ?? ""              // 5
            region = restNew.region?.rawValue ?? ""      // 6
            town = restNew.town ?? ""                    // 7
            tel = restNew.tel                            // 8
            opentime = restNew.opentime                  // 9
            website = restNew.website ?? ""              // 10
            picture1 = restNew.picture1                  // 11
            pic_describe1 = restNew.picdescribe1         // 12
            picture2 = restNew.picture2 ?? ""            // 13
            pic_describe2 = restNew.picdescribe2 ?? ""   // 14
            picture3 = restNew.picture3 ?? ""            // 15
            pic_describe3 = restNew.picdescribe3 ?? ""   // 16
            px = restNew.px                              // 17
            py = restNew.py                              // 18
            class_str = restNew.infoClass ?? ""          // 19
            map = restNew.map ?? ""                      // 20
            parking_info = restNew.parkinginfo ?? ""     // 21
            update_date = today                          // 22
            
            let sqlStr = "INSERT INTO restaurant (id, name, description, address, zipcode, region, town, tel, opentime, website, picture1, picdescribe1, picture2, picdescribe2, picture3, picdescribe3, px, py, class_str, map_str, parking_info, update_date) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
            
            updateDB(sqlStr: sqlStr)
            
            index += 1
        }
        
        //產生提示視窗
        let alert = UIAlertController(title: "資料更新成功", message: "總共\(index)筆餐廳資料", preferredStyle: .alert)
        //產生提示視窗內用的按鈕
        let okAction = UIAlertAction(title: "確定", style: .destructive)
        //將按鈕加入提示視窗
        alert.addAction(okAction)
        //顯示提示視窗
        self.present(alert, animated: true)
    }
    
    func updateDB(sqlStr:String) {
        
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
            sqlite3_bind_text(statement, 2, nameSql, -1, nil)
     
//            let gender = description.selectedRow(inComponent: 0)
//            sqlite3_bind_int(statement, 3, Int32(gender))

            //準備要綁定到第 3
            let descriptionSql = description_str.cString(using: .utf8)!
            sqlite3_bind_text(statement, 3, descriptionSql, -1, nil)
     
            
//            let imgData = imgPicture.image!.jpegData(compressionQuality: 0.7)!
//            sqlite3_bind_blob(statement, 4, (imgData as NSData).bytes, Int32(imgData.count), nil)
//

            //準備要綁定到第 4
            let addStrSql = add_str.cString(using: .utf8)!
            sqlite3_bind_text(statement, 4, addStrSql, -1, nil)
            
            //準備要綁定到第 5
            let zipcodeSql = zipcode.cString(using: .utf8)!
            sqlite3_bind_text(statement, 5, zipcodeSql, -1, nil)
            
            //準備要綁定到第 6
            let regionSql = region.cString(using: .utf8)!
            sqlite3_bind_text(statement, 6, regionSql, -1, nil)
            
            //準備要綁定到第 7
            let townStr = town.cString(using: .utf8)!
            sqlite3_bind_text(statement, 7, townStr, -1, nil)
            
            //準備要綁定到第 8
            let telSql = tel.cString(using: .utf8)!
            sqlite3_bind_text(statement, 8, telSql, -1, nil)
            
            //準備要綁定到第 9
            let opentimeSql = opentime.cString(using: .utf8)!
            sqlite3_bind_text(statement, 9, opentimeSql, -1, nil)
            
            //準備要綁定到第 10
            let websiteSql = website.cString(using: .utf8)!
            sqlite3_bind_text(statement, 10, websiteSql, -1, nil)
        
            //準備要綁定到第 11
            let picture1Sql = picture1.cString(using: .utf8)!
            sqlite3_bind_text(statement, 11, picture1Sql, -1, nil)
            
            //準備要綁定到第 12
            let picDescribe1Sql = pic_describe1.cString(using: .utf8)!
            sqlite3_bind_text(statement, 12, picDescribe1Sql, -1, nil)
        
            //準備要綁定到第 13
            let picture2Sql = picture2.cString(using: .utf8)!
            sqlite3_bind_text(statement, 13, picture2Sql, -1, nil)
            
            //準備要綁定到第 14
            let picDescribe2Sql = pic_describe2.cString(using: .utf8)!
            sqlite3_bind_text(statement, 14, picDescribe2Sql, -1, nil)
            
            //準備要綁定到第 15
            let picture3Sql = picture3.cString(using: .utf8)!
            sqlite3_bind_text(statement, 15, picture3Sql, -1, nil)
            
            //準備要綁定到第 16
            let picDescribe3Sql = pic_describe3.cString(using: .utf8)!
            sqlite3_bind_text(statement, 16, picDescribe3Sql, -1, nil)
            
            //準備要綁定到第 17
            sqlite3_bind_double(statement, 17, px)
            
            //準備要綁定到第 18
            sqlite3_bind_double(statement, 18, py)
            
            //準備要綁定到第 19
            let classStrSql = class_str.cString(using: .utf8)!
            sqlite3_bind_text(statement, 19, classStrSql, -1, nil)
            
            //準備要綁定到第 20
            let mapSql = map.cString(using: .utf8)!
            sqlite3_bind_text(statement, 20, mapSql, -1, nil)
            
            //準備要綁定到第 21
            let parkinginfoSql = parking_info.cString(using: .utf8)!
            sqlite3_bind_text(statement, 21, parkinginfoSql, -1, nil)
       
            //準備要綁定到第 22
            let dateSql = update_date.cString(using: .utf8)!
            sqlite3_bind_text(statement, 22, dateSql, -1, nil)
    
            //執行資料庫異動，如果執行不成功
            if sqlite3_step(statement!) != SQLITE_DONE
            {
                printError(with: "Could not insert a row")
                
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
            
            func printError(with message: String) {
                let errmsg = sqlite3_errmsg(db).flatMap { String(cString: $0) } ?? "Unknown error"
                print(message, errmsg)
            }
        }
        
    }
    


}
