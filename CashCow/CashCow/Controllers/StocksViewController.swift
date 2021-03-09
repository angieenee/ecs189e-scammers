//
//  StocksViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/6/21.
//

import UIKit

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

enum Order: String, Decodable {  case asc, desc }
enum Frequency: String, Decodable { case  daily, weekly, monthly, quarterly, annual }

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

class StockCell: UITableViewCell {
    @IBOutlet weak var stockCode: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
}

class StocksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var user: User?
    let API_KEY = "QxgT-zxMrt3AYy2xUhhA"
    var stockCodes = ["APPL": "Apple", "DIS": "Walt Disney", "HD": "Home Depot", "MSFT": "Microsoft"]
    var stocks: [TimeSeries] = []
    
    @IBOutlet weak var stocksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stocksTableView.dataSource = self
        self.stocksTableView.delegate = self
        
        var url = "https://www.quandl.com/api/v3/datasets/EOD/AAPl/data.json?api_key=\(API_KEY)"
        print(url)
        if let nsurl = URL(string: url) {
            print(nsurl)
            URLSession.shared.dataTask(with: nsurl) { data, response, error in
                print("STOCK DATA ------")
                //print(data)
                //print(response)
//                if let d = data {
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: d, options: []) as? [String : Any]
//                        print(json)
//                    } catch {
//                        print("Error converting to JSON")
//                    }
//                }
                guard error == nil else {
                    print("Error: \(error!)")
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    print("Bad Response")
                    return
                }
                guard response.statusCode == 200 else {
                    print("Bad Response: \(response.statusCode)")
                    return
                }
                guard let data = data else {
                    print("No data")
                    return
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.calendar = Calendar(identifier: .iso8601)
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(formatter)
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                if let result = try? decoder.decode(TimeSeries.self, from: data) {
                    print(result.datasetData)
                    self.stocks.append(result)
                    
                    // Update table in UI thread
                    DispatchQueue.main.async() {
                        self.stocksTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: StockCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "stockCell") as? StockCell {
            cell = reuseCell
        } else {
            cell = StockCell(style: .default, reuseIdentifier: "stockCell")
        }
        
        cell.stockCode.text = Array(stockCodes.keys)[indexPath.row]
        cell.stockName.text = stockCodes[Array(stockCodes.keys)[indexPath.row]]
        if let rand = stocks[indexPath.row].datasetData.data.randomElement() {
            cell.open.text = String(rand.data[0])
            cell.high.text = String(rand.data[1])
            cell.low.text = String(rand.data[2])
            cell.price.text = String(rand.data[3])
        }
        return cell
    }
}
