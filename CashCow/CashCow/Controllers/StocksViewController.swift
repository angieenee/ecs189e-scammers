//
//  StocksViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/6/21.
//

import UIKit
import FirebaseDatabase

// Start JSON schema Decodable for Quandl API data from "thisischemistry" on Reddit
// https://www.reddit.com/r/swift/comments/9ximzk/live_financial_data_using_yahoo_finance_or_quandl/

struct TimeSeriesData {
  let date: Date
  let data: [Float]
}

extension TimeSeriesData : Decodable {

  init(from: Decoder) throws {
    var container = try from.unkeyedContainer()
    self.date = try container.decode(Date.self)
    var floatData: [Float] = []
    
    while !container.isAtEnd {
      try floatData.append(container.decode(Float.self))
    }
    
    self.data = floatData
  }
}

enum Order: String, Decodable {
    case asc, desc
}

enum Frequency: String, Decodable {
    case  daily, weekly, monthly, quarterly, annual
}

struct DatasetData: Decodable {
  let limit: Int?
  let columnIndex: Int?
  let columnNames: [String]
  let startDate: Date
  let endDate: Date
  let frequency: Frequency
  let data: [TimeSeriesData]
  let collapse: Frequency?
  let order: Order?
}

struct TimeSeries: Decodable {
  let datasetData: DatasetData
}

// End JSON schema Decodable from Reddit

class StocksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user: User?
    var ref = Database.database().reference().child("users")
    let API_KEY = "QxgT-zxMrt3AYy2xUhhA"
    
    var stockCodes = ["AAPL": "Apple", "DIS": "Walt Disney", "HD": "Home Depot", "MSFT": "Microsoft"]
    var stocksData: [String: TimeSeries] = [:]
    var stocksDict: [[String: Any]]?
    
    @IBOutlet weak var stocksTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wait()
        
        self.stocksTableView.dataSource = self
        self.stocksTableView.delegate = self
        
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        
        guard let uid = user?.uid else {
            print("rip")
            return
        }
        
        // Load stock data from Firebase
        ref.child(uid).child("date").observe( .value, with: { snapshot in
            if let data = snapshot.value as? [String: Any] {
                // If new day, then load new data from Quandl API
                if data["year"] as? Int != components.year || data["month"] as? Int != components.month || data["day"] as? Int != components.day {
                    self.getStocksFromAPI() {
                        self.setStocksDict(uid) {
                            let post = ["year": components.year, "day": components.day, "month": components.month]
                            
                            // Post new date to Firebase for future reference
                            self.ref.child(uid).child("date").setValue(post) {
                                (error: Error?, ref:DatabaseReference) in
                                if let error = error {
                                    print("Data could not be saved: \(error).")
                                } else {
                                    print("Data saved successfully!")
                                    self.stocksTableView.reloadData()
                                    self.start()
                                }
                            }
                        }
                    }
                // Otherwise populate table with existing stock data
                } else {
                    // Get stock data from Firebase
                    self.ref.child(uid).child("stocks").observe(.value, with: { snapshot in
                        if let data = snapshot.value as? [[String: Any]] {
                            self.stocksDict = data
                            self.stocksTableView.reloadData()
                            self.start()
                        } else {
                            // No existing stock data - get from Quandl API
                            print("No stock data")
                            if self.stocksDict == nil {
                                self.getStocksFromAPI() {
                                    self.setStocksDict(uid) {
                                        self.stocksTableView.reloadData()
                                        self.start()
                                    }
                                }
                            }
                        }
                    })
                }
            } else {
                // No existing date in Firebase - post new date for future reference
                let post = ["year": components.year, "day": components.day, "month": components.month]
                self.ref.child(uid).child("date").setValue(post) {
                    (error: Error?, ref: DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                    }
                }
            }
        })
    }
    
    // Set dictionary for populating table view
    func setStocksDict(_ uid: String, completion: @escaping () -> Void) {
        if let count = self.stocksData["AAPL"]?.datasetData.data.count {
            let rand = Int.random(in: 1..<count)
            self.stocksDict = [
                        ["code": "AAPL",
                        "name": "Apple",
                        "price": self.stocksData["AAPL"]?.datasetData.data[rand].data[3],
                        "open": self.stocksData["AAPL"]?.datasetData.data[rand].data[0],
                        "high": self.stocksData["AAPL"]?.datasetData.data[rand].data[1],
                        "low": self.stocksData["AAPL"]?.datasetData.data[rand].data[2],
                        "currency": "A"],
                        ["code": "DIS",
                        "name": "Walt Disney",
                        "price": self.stocksData["DIS"]?.datasetData.data[rand].data[3],
                        "open": self.stocksData["DIS"]?.datasetData.data[rand].data[0],
                        "high": self.stocksData["DIS"]?.datasetData.data[rand].data[1],
                        "low": self.stocksData["DIS"]?.datasetData.data[rand].data[2],
                        "currency": "B"],
                        ["code": "HD",
                        "name": "Home Depot",
                        "price": self.stocksData["HD"]?.datasetData.data[rand].data[3],
                        "open": self.stocksData["HD"]?.datasetData.data[rand].data[0],
                        "high": self.stocksData["HD"]?.datasetData.data[rand].data[1],
                        "low": self.stocksData["HD"]?.datasetData.data[rand].data[2],
                        "currency": "C"],
                        ["code": "MSFT",
                        "name": "Microsoft",
                        "price": self.stocksData["MSFT"]?.datasetData.data[rand].data[3],
                        "open": self.stocksData["MSFT"]?.datasetData.data[rand].data[0],
                        "high": self.stocksData["MSFT"]?.datasetData.data[rand].data[1],
                        "low": self.stocksData["MSFT"]?.datasetData.data[rand].data[2],
                        "currency": "D"]
                        ]
            
            // Save to Firebase
            self.ref.child(uid).child("stocks").setValue(self.stocksDict) {
                (error: Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                    completion()
                }
            }
        }
    }
    
    // Load stock data from Quandl API
    func getStocksFromAPI(completion: @escaping () -> Void) {
        for (key, _) in self.stockCodes {
            let url = "https://www.quandl.com/api/v3/datasets/EOD/\(key)/data.json?api_key=\(self.API_KEY)"
            if let nsurl = URL(string: url) {
                URLSession.shared.dataTask(with: nsurl) { data, response, error in
                    if let err = error {
                        print("Error: \(err)")
                    }
                    if let value = data {
                        // Formatting for JSONDecoder
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        formatter.calendar = Calendar(identifier: .iso8601)
                        formatter.timeZone = TimeZone(secondsFromGMT: 0)
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(formatter)
                        decoder.keyDecodingStrategy = .convertFromSnakeCase

                        // Attempt to decode into TimeSeries object
                        if let result = try? decoder.decode(TimeSeries.self, from: value) {
                            self.stocksData[key] = result
                            
                            // Update table in UI thread
                            DispatchQueue.main.async() {
                                // We're done here
                                if self.stocksData.count == self.stockCodes.count {
                                    completion()
                                }
                            }
                        }
                    }
                }.resume()
            }
            // Sleep for a bit so the API is not overwhelmed
            sleep(UInt32(1))
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksDict?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: StockCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as? StockCell {
            cell = reuseCell
        } else {
            cell = StockCell(style: .default, reuseIdentifier: "stockCell")
        }
        
        if let get = self.stocksDict?[indexPath.row] {
            cell.configureCell(code: get["code"] as? String, name: get["name"] as? String, price: get["price"] as? Float, open: get["open"] as? Float, high: get["high"] as? Float, low: get["low"] as? Float, currency: get["currency"] as? String, row: indexPath.row, user: self.user)
        }
        
        return cell
    }
    
    // activityIndicator methods
    func wait() {
        self.activityIndicator.startAnimating()
        self.view.alpha = 0.8
        self.view.isUserInteractionEnabled = false
        self.loadingLabel.isHidden = false
    }
    
    func start() {
        self.activityIndicator.stopAnimating()
        self.view.alpha = 1
        self.view.isUserInteractionEnabled = true
        self.loadingLabel.isHidden = true
    }
}
