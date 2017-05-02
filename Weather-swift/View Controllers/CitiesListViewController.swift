//
// Created by Kirill Pyulzyu on 26.04.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit

class CitiesListViewController: UIViewController, UITableViewDataSource {
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
        /*let cityModel = CityModel(name: "City", id: 1234)
        CitiesStorage.sharedInstance.addCity(cityModel: cityModel)
        self.refreshDatasource()
        self.tableView.reloadData()*/

        let vc = NewCityViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


    //MARK:table view
    var datasource = [CityModel]()

    func lazyTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
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
        cell.textLabel!.text = String(indexPath.row)
        return cell
    }


}