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
}
