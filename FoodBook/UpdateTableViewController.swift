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
    var zipcode = 0
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
    var classInt = 0
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
                    print(self.restNews[0])
                    
                } catch  {
                    print(error)
                }
            }

        }.resume()

    }
    
    func preperUpdateDB() {
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        let day:String = dateFormatter.string(from: today)
        
        // 刪除原來db的餐廳
        
        // 增加新的餐廳到db
        
//        for restNew in restNews {
//        }
        
        // 先試試看新增一筆
        var restNew = restNews[0]
        
        id = restNew.id
        name = restNew.name
        descriptionStr = restNew.infoDescription
        addStr = restNew.add
        zipcode = Int(restNew.zipcode!) ?? 0
        region = restNew.region!.rawValue
        town = restNew.town!
        tel = restNew.tel
        opentime = restNew.opentime
        website = restNew.website ?? ""
        picture1 = restNew.picture1
        picDescribe1 = restNew.picdescribe1
        picture2 = restNew.picture2 ?? ""
        picDescribe2 = restNew.picdescribe2 ?? ""
        picture3 = restNew.picture3 ?? ""
        picDescribe3 = restNew.picdescribe3 ?? ""
        px = restNew.px
        py = restNew.py
        classInt = Int(restNew.infoClass!) ?? 0
        map = restNew.map ?? ""
        parkinginfo = restNew.parkinginfo ?? ""
        date = day
        
        // INSERT INTO Store_Information (Store_Name, Sales, Txn_Date) VALUES ('Los Angeles', 900, 'Jan-10-1999');
        
        let sqlStr = "insert into student(name,gender,picture,phone,address,email,myclass) values(?,?,?,?,?,?,?,?)"
            

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
        
        
/*
        //準備異動資料（第三個參數：若為正數則限定SQL指令的長度，若為負數則不限SQL指令的長度。第四個參數和第六個參數為預留參數，目前沒有作用。第五個參數會儲存SQL指令的執行結果。）
        if sqlite3_prepare_v3(db!, cSql, -1, 0, &statement, nil) == SQLITE_OK
        {
            //準備要綁定到第一個問號的資料
            let no = txtNo.text!.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第一個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 1, no, -1, nil)
            //準備要綁定到第二個問號的資料
            let name = txtName.text!.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第二個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 2, name, -1, nil)
            
            //準備要綁定到第三個問號的資料
            let gender = pkvGender.selectedRow(inComponent: 0)
            //將資料綁定到update指令<參數一>的第三個問號<參數二>，指定介面上的資料<參數三>。
            sqlite3_bind_int(statement, 3, Int32(gender))
            
            //準備要綁定到第四個問號的資料
            let imgData = imgPicture.image!.jpegData(compressionQuality: 0.7)!
            //將資料綁定到update指令<參數一>的第四個問號<參數二>，指定介面上圖檔的位元資料<參數三>，以及檔案長度<參數四>，參數五為預留參數。
            sqlite3_bind_blob(statement, 4, (imgData as NSData).bytes, Int32(imgData.count), nil)
            
            //準備要綁定到第五個問號的資料
            let phone = txtPhone.text!.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第五個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 5, phone, -1, nil)
            
            //準備要綁定到第六個問號的資料
            let address = txtAddress.text!.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第六個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 6, address, -1, nil)
            
            //準備要綁定到第七個問號的資料
            let email = txtEmail.text!.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第七個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 7, email, -1, nil)
            
            //準備要綁定到第八個問號的資料
            let myclass = txtMyclass.text!.cString(using: .utf8)!
            //將資料綁定到update指令<參數一>的第八個問號<參數二>，指定介面上的資料<參數三>，且不指定資料長度<參數四為負數>，參數五為預留參數。
            sqlite3_bind_text(statement, 8, myclass, -1, nil)
            
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
                //關閉連線資料集
                if statement != nil
                {
                    sqlite3_finalize(statement!)
                }
            }
        }
 */
        
    }
    
 
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
