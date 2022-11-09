//
//  UpdateTableViewController.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/10/25.
//
//  https://data.gov.tw/dataset/7779
//
import UIKit

class UpdateTableViewController: UITableViewController {

    var restNews = [Info]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
    @IBAction func updateButton(_ sender: Any) {
        
        update()
    }
    
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
