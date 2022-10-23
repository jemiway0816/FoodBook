//
//  ListTableViewController.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/10/23.
//

import UIKit
import Kingfisher

class ListTableViewController: UITableViewController {

    
    var restaurants = [Restaurant]()
    
    var restaurants2 = [
    
        Restaurant(id: "C3_315080500H_000013", name: "望海巴耐餐廳/咖啡", description: "非常有特色的原住民餐點餐廳，位於台十一線8K區段上，是東海岸行經花蓮大橋進入東海岸國家風景區之後，花蓮遊客中心前，第一家餐飲服務業者；業者於建物外部以當地竹子搭蓋起大門及挑高竹亭，呈顯其自然風格建築形式是其特色。望海巴耐野菜餐廳位於台十一線8K區段上，是東海岸行經花蓮大橋進入東海岸國家風景區之後，花蓮遊客中心前，第一家餐飲服務業者；業者於建物外部以當地竹子搭蓋起大門及挑高竹亭，呈顯其自然風格建築形式是其特色。", add: "花蓮縣974壽豐鄉鹽寮村大橋22號", zipcode: 974, region: "花蓮縣", town: "壽豐鄉", tel: "886-9-37533483", openTime: "11:30 - 20:00", website: "", picture1: "https://www.eastcoast-nsa.gov.tw/image/41530/640x480", picDescribe1: "花蓮無敵海景咖啡餐廳-望海巴耐", picture2: "", picDescribe2: "", picture3: "", picDescribe3: "", px: 121.606110, py: 23.918950, classLevel: 9, map: "", parkingInfo: ""),
        Restaurant(id: "C3_315080500H_000016", name: "噶瑪蘭海產店", description: "沒有固定菜單，菜單依照時節隨時更新，主要客群來自附近居民及固定客戶，業者也和附近民宿配合，接待海天、118、沙漠風情、來去海邊等民宿的住房遊客。主要菜色為海鮮料理及噶瑪蘭風味料理，餐廳本身還有供簡易之餐飲服務，可容納約90~120人，這是一間原住民風格濃厚的餐廳。", add: "花蓮縣977豐濱鄉新社村42號", zipcode: 977, region: "花蓮縣", town: "豐濱鄉", tel: "886-3-8711339", openTime: "11:00 - 14:00、17:00 - 19:00", website: "", picture1: "https://www.eastcoast-nsa.gov.tw/image/51996/640x480", picDescribe1: "噶瑪蘭海產店", picture2: "", picDescribe2: "", picture3: "", picDescribe3: "", px: 121.537790, py: 23.653180, classLevel: 9, map: "", parkingInfo: ""),
        Restaurant(id: "C3_315080500H_000018", name: "口福海鮮餐廳", description: "位處石梯港邊，臨近昕陽餐廳，同時也是東部賞鯨一號的報名處，餐廳主要提供海鮮熱炒料理，室內空間可容納200人以上，淡季客源除了過路觀光客，主要接待當地及附近居民，旺季則以接待遊覽車團體客人為主，是吃飯加賞鯨的好所在。東海岸的石梯坪有湛藍的海景、豐富多樣的海產，口福海鮮餐廳就設在花蓮南區最大的石梯港旁，出產多種迴游魚類、底棲珊瑚礁魚類、東海岸龍蝦，每天早上自家的漁船出海捕撈最新鮮的海產，招牌餐點有生魚片、多種鮮魚料理、東海岸活龍蝦、新鮮鮑魚及各種山、海產料理，不僅品質極佳價錢更是經濟實惠，保證讓您大飽口福，是您旅行東海岸最佳的用餐休息站。", add: "花蓮縣977豐濱鄉石梯港82號", zipcode: 977, region: "花蓮縣", town: "豐濱鄉", tel: "886-3-8781041", openTime: "11:00 - 14:00 、 17:00 - 19:30", website: "", picture1: "https://www.eastcoast-nsa.gov.tw/image/41544/640x480", picDescribe1: "口福海鮮餐廳", picture2: "", picDescribe2: "", picture3: "", picDescribe3: "", px: 121.510850, py: 23.488160, classLevel: 9, map: "", parkingInfo: "")
    
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants2.count
    }

    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailTableViewController? {
        
        let controller = DetailTableViewController(coder: coder)
        
        if let row = tableView.indexPathForSelectedRow?.row {
            
            controller?.rest = restaurants2[row]
            
        }
        return controller
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as! ListTableViewCell
        
        let rest = restaurants2[indexPath.row]
        
        cell.cellImageView.kf.setImage(with: URL(string: rest.picture1))
        cell.cellNameLabel.text = rest.name
        cell.cellRegionLabel.text = "\(rest.region) \(rest.town)"

        return cell
    }
    

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
