//
// Created by Kirill Pyulzyu on 02.05.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit

let searchBarHeight = 50.0


class NewCityViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    lazy var searchBar: UISearchBar = self.lazySearchBar()
    lazy var tableView: UITableView = self.lazyTableView()
    var datasource = Array<CityModel>()
    var blockOnCitySelected:((_ cityModel:CityModel)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initUI()
    }


    func initUI(){
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
    }


    //MARK: Search bar

    func lazySearchBar() -> UISearchBar {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: Int(searchBarHeight)))
        searchBar.delegate = self
        return searchBar
    }


    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).characters.count>2{
            self.requestCities(cityName: searchText)
        }
        else if (searchText.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0){
            updateDatasource(remoteDict: nil)
            self.tableView.reloadData()
        }
    }


    //MARK: tableview

    func lazyTableView()->UITableView{
        let tableView = UITableView(frame: CGRect(x: 0.0, y: searchBarHeight, width: Double(self.view.bounds.size.width), height: Double(self.view.bounds.size.height) - searchBarHeight), style: .plain)
        tableView.delegate = self;
        tableView.dataSource = self;
        return tableView
    }


    func updateDatasource(remoteDict:Dictionary<String, Any>?){
        if let remoteDict = remoteDict{
            self.datasource = [CityModel(remoteDictCity: remoteDict)]
        }
        else
        {
            self.datasource = []
        }
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cityModel:CityModel = self.datasource[indexPath.row]
        cell.textLabel!.text = cityModel.name
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cityModel = self.datasource[indexPath.row] as CityModel?{
            if self.blockOnCitySelected != nil{
                self.blockOnCitySelected!(cityModel)
                self.navigationController!.popViewController(animated: true)
            }
        }
    }


    //MARK: request
    func requestCities(cityName:String){
        let session = URLSession(configuration: .default)
        let urlString = "api.openweathermap.org/data/2.5/weather"

        var urlComponents = URLComponents(string: urlString)
        urlComponents?.scheme = "http"
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "APPID", value: "c4d1e7389a2e0605f6e44bd8d42c97e7"),
            URLQueryItem(name: "units", value: "metric")
        ]

        let url = urlComponents?.url

        
        let task = session.dataTask(with: url!) {
            data, response, error in
            if let error = error{
                print(error.localizedDescription)
            }else if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    let dict:Dictionary<String, Any>
                    dict = try! JSONSerialization.jsonObject(with:data!) as! Dictionary<String, Any>
                    self.updateDatasource(remoteDict: dict)
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
            }
        }
        task.resume()
    }



    
}


