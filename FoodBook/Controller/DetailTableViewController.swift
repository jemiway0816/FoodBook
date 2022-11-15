//
//  DetailTableViewController.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/10/23.
//

import UIKit
import Kingfisher
import SafariServices

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var datailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet var detailName: UILabel!
    
    @IBOutlet var detailAddressLabel: UILabel!
    @IBOutlet var detailTelLabel: UILabel!
    @IBOutlet var detailOpenTimeLabel: UILabel!
    @IBOutlet var detailWebSite: UIButton!
    
    
    var rest:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailName.text = rest.name
        datailDescriptionLabel.text = rest.description
        detailAddressLabel.text = "住址 : " + rest.add
        detailTelLabel.text = "電話 : " + rest.tel
        detailOpenTimeLabel.text = rest.openTime
        
        print("rest.website = \(rest.website)")
        
        if rest.website == "" {
            detailWebSite.isEnabled = false
        } else {
            detailWebSite.isEnabled = true
        }
        
//        detailImageView.kf.setImage(with: URL(string: rest.picture1))
        
        if let url = URL(string: rest.picture1) {
            detailImageView.kf.setImage(with: url)
            
        } else {
            let url = Bundle.main.url(forResource: "picture1", withExtension: "jpg")
            detailImageView.kf.setImage(with: url)
        }

    }


    @IBAction func showWebsiteBySF(_ sender: Any) {
        
        if let url = URL(string: rest.website) {
            
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
    }
    
    @IBSegueAction func showEwbSite(_ coder: NSCoder, sender: Any?) -> WebSiteViewController? {
        let controller = WebSiteViewController(coder: coder)
        controller?.urlStr = rest.website
        return controller
    }
    

    // MARK: - Table view data source



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
