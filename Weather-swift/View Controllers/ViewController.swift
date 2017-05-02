//
//  ViewController.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 13.04.17.
//  Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit


struct WeatherDayModel {
    let tempMin: Float?
    let tempMax: Float?
    let date: TimeInterval?

    init(remoteDict: Dictionary<String, Any>) {
        if let main = remoteDict["main"] as! Dictionary<String, Any>?,
           let tempMin = main["temp_min"] as! Float?,
           let tempMax = main["temp_max"] as! Float?,
           let date = remoteDict["dt"] as! TimeInterval? {
            self.tempMin = tempMin
            self.tempMax = tempMax
            self.date = date
        }
        else
        {
            self.tempMin = nil
            self.tempMax = nil
            self.date = nil
        }
    }
}

class ViewController: UIViewController, UITableViewDataSource {

    var cityName: String?
    var weatherDays = [WeatherDayModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initUI()
        getData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:UI

    lazy var tableView: UITableView = self.lazyTableView()
    var datasource = [WeatherDayModel]()

    func initUI() {
        self.view.addSubview(self.tableView)
    }

    func refreshDatasource() {
        self.datasource = self.weatherDays;
    }

    func lazyTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.dataSource = self;
        let statusBarHeigh = UIApplication.shared.statusBarFrame.size.height
        tableView.contentInset = UIEdgeInsets(top: statusBarHeigh, left: 0, bottom: 0, right: 0)
        return tableView;
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = self.tableView.dequeueReusableCell(withIdentifier: "dayCell")
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "dayCell")
        }
        
        cell = configureCell(cell!, at: indexPath)

        return cell!
    }
    
    
    func configureCell(_ cell:UITableViewCell, at indexPath:IndexPath)->UITableViewCell {
        let model = self.datasource[indexPath.row]
        let dateTimeFormater = DateFormatter()
        dateTimeFormater.timeStyle = .short
        dateTimeFormater.dateStyle = .short
        let dateString = dateTimeFormater.string(from: Date(timeIntervalSince1970: model.date!))
        let maxTempString = String(model.tempMax!)
        let minTempString = String(model.tempMax!)
        
        let tempString = "From \(minTempString) to \(maxTempString)"
        
        cell.textLabel?.text = tempString;
        cell.detailTextLabel?.text = dateString
        
        return cell
    }



    //MARK: Data
    func getData() {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=c4d1e7389a2e0605f6e44bd8d42c97e7&units=metric")


        dataTask = defaultSession.dataTask(with: url!) {
            data, response, error in

            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }

            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let dict: Dictionary<String, Any>?
                    dict = try! JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>

                    //TODO:change "self" to "weakSelf"
                    self.parseAndSaveData(remoteDict: dict)
                    
                    DispatchQueue.main.async {
                        self.refreshDatasource()
                        self.tableView.reloadData()
                    }
                }
            }
        }

        dataTask?.resume()
    }


    func parseAndSaveData(remoteDict: Dictionary<String, Any>?) -> Void {
        if let city = remoteDict!["city"] as! Dictionary<String, Any>?,
           let cityName = city["name"] as! String? {
            self.cityName = cityName
        }



        if let weatherDaysDicts = remoteDict!["list"] as! Array<Any>? {
            weatherDaysDicts.forEach {
                weatherDays.append(WeatherDayModel.init(remoteDict: $0 as! Dictionary<String, Any>))
            }
        }


        self.printData()
    }


    //MARK: utilites
    func printData() {
        print("Parse done. City name \(String(describing: self.cityName)) \n and here is weather days:")
        weatherDays.forEach {
            print($0)
        }
    }
}
