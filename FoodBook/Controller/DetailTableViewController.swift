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
    
    @IBOutlet weak var favButton: UIButton!
    
    
    var favButtonEnable:Bool!
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
        
        if favButtonEnable == true {
            favButton.isHidden = false
        } else {
            favButton.isHidden = true
        }

    }

    @IBAction func showWebsiteBySF(_ sender: Any) {
        
        if let url = URL(string: rest.website) {
            
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
    }
    
    @IBAction func favRestAddButton(_ sender: Any) {
  
        // 取得餐廳列表頁的 controller
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let listViewController = navController?.viewControllers.first as? ListTableViewController
        
        listViewController?.favRests.insert(rest, at: 0)
        
        print("favRest ===> \(listViewController!.favRests)")
        
        Restaurant.saveToFile(favRest: listViewController!.favRests)
        
        //產生提示視窗
        let alert = UIAlertController(title: "我的最愛加入成功", message: "已將\(rest.name)餐廳加入我的最愛", preferredStyle: .alert)
        //產生提示視窗內用的按鈕
        let okAction = UIAlertAction(title: "確定", style: .destructive)
        //將按鈕加入提示視窗
        alert.addAction(okAction)
        //顯示提示視窗
        self.present(alert, animated: true)
        
    }
    
    
    
}
