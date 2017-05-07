//
// Created by Kirill Pyulzyu on 26.04.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit

class CitiesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    lazy var tableView: UITableView = self.lazyTableView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateNavBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    private func initUI() {
        self.view.addSubview(self.tableView)
    }

    //MARK:nav bar
    private func updateNavBar() {
        let btnPlus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onBtnAddTapped(_:)))
        self.navigationItem.rightBarButtonItem = btnPlus
    }

    func onBtnAddTapped(_ sender: UIButton) {
        self.switchToNewCityVC()
    }


    //MARK:table view
    var datasource = [CityModel]()

    func lazyTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }

    func refreshDatasource(){
        self.datasource = CitiesStorage.sharedInstance.allCities()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if let cityModel = self.datasource[indexPath.row] as CityModel?{
            cell.textLabel!.text = cityModel.name
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cityModel = CitiesStorage.sharedInstance.allCities()[indexPath.row]
        let vc = CityDetailsViewController(cityModel: cityModel)
        self.navigationController!.pushViewController(vc, animated: true)
    }



    //MARK: others
    func switchToNewCityVC(){
        let vc = NewCityViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.blockOnCitySelected = {
            (cityModel:CityModel) in
            CitiesStorage.sharedInstance.addCity(cityModel: cityModel)
            self.refreshDatasource()
            self.tableView.reloadData()
        }
    }


}
