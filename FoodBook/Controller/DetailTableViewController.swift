
import UIKit
import Kingfisher
import SafariServices
import MapKit

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet var detailName: UILabel!
    @IBOutlet weak var detailDescriptionTextField: UITextView!
    
    @IBOutlet var detailTelLabel: UILabel!
    @IBOutlet var detailWebSite: UIButton!
    
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var detailAddressTextField: UITextView!
    @IBOutlet weak var detailOpenTimeTextField: UITextView!
    
    var favButtonEnable:Bool!
    var rest:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailName.text = rest.name
        detailDescriptionTextField.text = rest.description
        detailAddressTextField.text = rest.add
        detailTelLabel.text = rest.tel
        detailOpenTimeTextField.text = rest.openTime
        
//        print("rest.website = \(rest.website)")
        
        if rest.website == "" {
            detailWebSite.isEnabled = false
        } else {
            detailWebSite.isEnabled = true
        }
        
        if let url = URL(string: rest.picture1) {
            detailImageView.kf.setImage(with: url)
            
        } else {
            let url = Bundle.main.url(forResource: "picture1", withExtension: "jpg")
            detailImageView.kf.setImage(with: url)
        }
        detailImageView.layer.cornerRadius = 8
        
        if favButtonEnable == true {
            favButton.isHidden = false
        } else {
            favButton.isHidden = true
        }

    }

    @IBAction func startNavButton(_ sender: Any) {
        
        //初始化地理資訊編碼器
        let geoCoder = CLGeocoder()
        //<#[CLPlacemark]?#>
        //讓地理資訊編碼器將地址轉換成經緯度
        geoCoder.geocodeAddressString(rest.add) { placemarks, error in
            //如果地址編碼失敗
            guard error == nil
            else
            {
//                print("地址錯誤！")
                //產生提示視窗
                let alert = UIAlertController(title: "轉換問題", message: "地址錯誤！", preferredStyle: .alert)
                //產生提示視窗內用的按鈕
                let okAction = UIAlertAction(title: "確定", style: .destructive)
                //將按鈕加入提示視窗
                alert.addAction(okAction)
                //顯示提示視窗
                self.present(alert, animated: true)
                //離開函式
                return
            }
            //如果轉換經緯度失敗
            guard placemarks != nil
            else
            {
//                print("地址轉換經緯度失敗！")
                //產生提示視窗
                let alert = UIAlertController(title: "轉換問題", message: "地址轉換經緯度失敗！", preferredStyle: .alert)
                //產生提示視窗內用的按鈕
                let okAction = UIAlertAction(title: "確定", style: .destructive)
                //將按鈕加入提示視窗
                alert.addAction(okAction)
                //顯示提示視窗
                self.present(alert, animated: true)
                //離開函式
                return
            }
//            print("編碼完成")
            //當回傳的經緯度不是空陣列時
            if !placemarks!.isEmpty
            {
                //Step1.取得(第一層)由地址轉換而成的經緯度位置標示
                let toPlacemark = placemarks!.first!
                
                //Step2.(第二層)將第一層的經緯度位置標示轉換成地圖上的位置標示
                let toPin = MKPlacemark(placemark: toPlacemark)
                print("經度：\(toPin.coordinate.longitude)，緯度：\(toPin.coordinate.latitude)")
                
                //Step3.(第三層)產生導航地圖上導航終點的大頭針
                let destMapItem = MKMapItem(placemark: toPin)
                
                //Step4.開啟導航地圖
                //Step4_1.設定以開車模式導航
                let option = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                //Step4_2.以導航終點的大頭針來開啟導航地圖（從目前位置導航）
                destMapItem.openInMaps(launchOptions: option)
            }
            else
            {
//                print("沒有取得導航用的經緯度")
                //產生提示視窗
                let alert = UIAlertController(title: "轉換問題", message: "沒有取得導航用的經緯度！", preferredStyle: .alert)
                //產生提示視窗內用的按鈕
                let okAction = UIAlertAction(title: "確定", style: .destructive)
                //將按鈕加入提示視窗
                alert.addAction(okAction)
                //顯示提示視窗
                self.present(alert, animated: true)
            }
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
        
//        print("favRest ===> \(listViewController!.favRests)")
        
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
