//
//  ViewController.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 13.04.17.
//  Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

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
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=c4d1e7389a2e0605f6e44bd8d42c97e7")


        dataTask = defaultSession.dataTask(with: url!){
            data, response, error in

            DispatchQueue.main.async() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }

            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let dict = try! JSONSerialization.jsonObject(with: data!)
                    print(dict);
                }
            }
        }

        dataTask?.resume()
    }



}
