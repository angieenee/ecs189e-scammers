//
//  StocksViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/6/21.
//

import UIKit

class StocksViewController: UIViewController {
    var user: User?
    let API_KEY = "QxgT-zxMrt3AYy2xUhhA"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://www.quandl.com/api/v3/datasets/EOD/AAPL/data.json?api_key=\(API_KEY)"
        print(url)
        if let nsurl = URL(string: url) {
            print(nsurl)
            URLSession.shared.dataTask(with: nsurl) { data, response, error in
                print("STOCK DATA ------")
                //print(data)
                //print(response)
                if let d = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String : Any]
                        print(json)
                    } catch {
                        print("Error converting to JSON")
                    }
                }
            }.resume()
        }
    }

    @IBAction func backButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clickerViewController =  storyboard.instantiateViewController(identifier: "clickerViewController") as? ClickerViewController else {
            assertionFailure("Couldn't find Profile VC")
            return
        }
        clickerViewController.user = self.user
        
        // Push to stack because we want users to be able to go back to clicker view
        let viewControllers = [clickerViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
}
