//
//  FavTableViewController.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/11/18.
//

import UIKit

class FavTableViewController: UITableViewController {

    var favRests:[Restaurant]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFavRests()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        getFavRests()
        tableView.reloadData()
    }
    
    func getFavRests() {
        
        // 取得餐廳列表頁的 controller
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let listViewController = navController?.viewControllers.first as? ListTableViewController
        
        self.favRests = listViewController?.favRests
//        print("----->> \(favRests!)")
    }
    
    @IBSegueAction func showDetailSegue(_ coder: NSCoder) -> DetailTableViewController? {
        
        let controller = DetailTableViewController(coder: coder)
        
        controller?.favButtonEnable = false
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.rest = favRests[row]
        }
        
        return controller
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favRests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(FavTableViewCell.self)", for: indexPath) as! FavTableViewCell

        let favRest = favRests[indexPath.row]
        
        if let url = URL(string: favRest.picture1) {
            cell.cellFavImageView.kf.setImage(with: url)
        } else {
            let url = Bundle.main.url(forResource: "picture1", withExtension: "jpg")
            cell.cellFavImageView.kf.setImage(with: url)
        }
        cell.cellFavImageView.layer.cornerRadius = 8
        
        cell.cellFavNameLabel.text = favRest.name
        cell.cellFavRegionLabel.text = "\(favRest.region) \(favRest.town)"
        
        cell.cellFavWebsiteLabel.clipsToBounds = true
        cell.cellFavWebsiteLabel.backgroundColor = .orange
        cell.cellFavWebsiteLabel.layer.cornerRadius = 5
        
        if favRest.website == "" {
            cell.cellFavWebsiteLabel.isHidden = true
        } else {
            cell.cellFavWebsiteLabel.isHidden = false
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        favRests.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // 取得餐廳列表頁的 controller
        let navController = tabBarController?.viewControllers?[0] as? UINavigationController
        let listViewController = navController?.viewControllers.first as? ListTableViewController
        
        listViewController?.favRests = self.favRests
        Restaurant.saveToFile(favRest: self.favRests)
    }
}
