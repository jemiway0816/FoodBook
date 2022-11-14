//
//  WebSiteViewController.swift
//  FoodBook
//
//  Created by Jemiway on 2022/11/14.
//

import UIKit
import WebKit

class WebSiteViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var urlStr:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: urlStr) {

            let request = URLRequest(url: url)
            webView.load(request)

        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
