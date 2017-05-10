//
//  VCCityDetails.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 13.04.17.
//  Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit


class VCCityDetails: UIViewController, UITableViewDataSource {

    var cityName: String?
    var weatherDays = [WeatherItemModel]()
    var cityModel: CityModel?

    lazy var tableView: UITableView = self.lazyTableView()
    var datasource = [WeatherItemModel]()


    init(cityModel: CityModel) {
        super.init(nibName: nil, bundle: nil)
        self.cityModel = cityModel
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        getData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:UI


    func initUI() {
        self.view.addSubview(self.tableView)
    }

    //MARK:table

    func refreshDatasource() {

        self.datasource.removeAll()

        var lastDay:Int?
        self.weatherDays.forEach {
            (model: WeatherItemModel) in
            let weatherItemDay = self.dayNumFromTimeInterval(model.date!)
            guard lastDay != weatherItemDay
            else{
                return
            }
            self.datasource.append(model)
            lastDay = weatherItemDay
        }
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
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "dayCell")
        }

        cell = configureCell(cell!, at: indexPath)

        return cell!
    }


    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) -> UITableViewCell {
        let model = self.datasource[indexPath.row]
        let dateTimeFormater = DateFormatter()
        dateTimeFormater.dateStyle = .medium
        let dateString = dateTimeFormater.string(from: Date(timeIntervalSince1970: model.date!))
        let midTemp = (model.tempMax!+model.tempMin!)/2


        cell.textLabel?.text = dateString
        cell.detailTextLabel?.text = "\(midTemp)"

        return cell
    }



    //MARK: Data
    func getData() {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        var urlComponents = URLComponents(string: "api.openweathermap.org/data/2.5/forecast")
        urlComponents!.scheme = "http"
        urlComponents!.queryItems = [
                URLQueryItem(name: "id", value: String(self.cityModel!.id!)),
                URLQueryItem(name: "APPID", value: "c4d1e7389a2e0605f6e44bd8d42c97e7"),
                URLQueryItem(name: "units", value: "metric")
        ]

        let url = urlComponents!.url

        dataTask = defaultSession.dataTask(with: url!) {
            (data: Data?, response: URLResponse?, error: Error?) in

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
                weatherDays.append(WeatherItemModel.init(remoteDict: $0 as! Dictionary<String, Any>))
            }
        }
    }


    //MARK: utilites
    func printData() {
        print("Parse done. City name \(String(describing: self.cityName)) \n and here is weather days:")
        weatherDays.forEach {
            print($0)
        }
    }

    //TODO: move to date extension
    func dayNumFromTimeInterval(_ timeInterval:TimeInterval)->Int{
        let date = Date(timeIntervalSince1970: timeInterval)
        let calendar = Calendar.current
        let calendarComponents = calendar.dateComponents([.day], from: date)
        let day = calendarComponents.day
        return day!
    }
}
