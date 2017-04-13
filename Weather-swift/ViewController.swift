//
//  ViewController.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 13.04.17.
//  Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit


struct WeatherDayModel
{
    let tempMin:Float?
    let tempMax:Float?
    let date:TimeInterval?

    init(remoteDict:Dictionary<String, Any>)
    {
        guard let main = remoteDict["main"] as! Dictionary<String, Any>?,
            let tempMin = main["temp_min"] as! Float?,
            let tempMax = main["temp_max"] as! Float?,
            let date = remoteDict["dt"] as! TimeInterval? else{
            self.tempMin = nil
            self.tempMax = nil
            self.date = nil
            return
        }

        self.tempMin = tempMin
        self.tempMax = tempMax
        self.date = date
    }
}


class ViewController: UIViewController {

    var cityName:String?
    var weatherDays = [WeatherDayModel]()

    override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        self.getData()
    }


    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }


    func getData() {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=c4d1e7389a2e0605f6e44bd8d42c97e7&units=metric")


        dataTask = defaultSession.dataTask(with: url!){
            data, response, error in

            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }

            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let dict:Dictionary<String, Any>?
                    dict = try! JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>

                    //TODO:change "self" to "weakSelf"
                    self.parseAndSaveData(remoteDict: dict)
                }
            }
        }

        dataTask?.resume()
    }


    func parseAndSaveData(remoteDict:Dictionary<String, Any>?)->Void
    {
        guard let city = remoteDict!["city"] as! Dictionary<String, Any>?,
                let cityName = city["name"] as! String? else{
            return
        }

        self.cityName = cityName

        guard let weatherDaysDicts = remoteDict!["list"] as! Array<Any>? else{
            return
        }

        weatherDaysDicts.forEach {
            weatherDays.append(WeatherDayModel.init(remoteDict: $0 as! Dictionary<String, Any>))
        }

        self.printData()
    }


    func printData()
    {
        print("Parse done. City name \(String(describing: self.cityName)) \n and here is weather days:")
        weatherDays.forEach {
            print($0)
        }
    }


}
