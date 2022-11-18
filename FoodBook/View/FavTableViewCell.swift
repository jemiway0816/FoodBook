//
//  FavTableViewCell.swift
//  FoodBook
//
//  Created by CHUN-CHIEH LU on 2022/11/18.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var cellFavImageView: UIImageView!
    @IBOutlet weak var cellFavNameLabel: UILabel!
    @IBOutlet weak var cellFavRegionLabel: UILabel!
    @IBOutlet weak var cellFavWebsiteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
