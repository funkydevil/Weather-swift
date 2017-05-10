//
// Created by Kirill Pyulzyu on 26.04.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit
import CoreData

class VCCitiesList: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    lazy var tableView: UITableView = self.lazyTableView()
    lazy var fetchResultsController: NSFetchedResultsController<NSManagedObject> = self.lazyFetchResultsController()

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
        //self.switchToNewCityVC()
        let cityModel = CityModel(name: "Norilsk", id: 1)
        let cdCity: CDCity = CDCitiesStorage.sharedInstance.addCity(cityModel: cityModel)
    }


    //MARK:table view
    var datasource = [CityModel]()

    func lazyTableView() -> UITableView {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }


    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = self.fetchResultsController.sections?[section]
                else {
            return 0
        }

        return section.numberOfObjects
    }


    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cdCity = self.fetchResultsController.object(at: indexPath) as! CDCity
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = cdCity.name
        return cell
    }


    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cityModel = CitiesStorage.sharedInstance.allCities()[indexPath.row]
        let vc = VCCityDetails(cityModel: cityModel)
        self.navigationController!.pushViewController(vc, animated: true)
    }



    //MARK: fetch results controller
    func lazyFetchResultsController() -> NSFetchedResultsController<NSManagedObject> {

        let fetchRequest = CDCity.sortedFetchRequest
        fetchRequest.fetchBatchSize = 20
        fetchRequest.returnsObjectsAsFaults = false

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: CDCitiesStorage.sharedInstance.container!.viewContext,
                sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self

        try! frc.performFetch()

        return frc
    }





    //MARK: others
    func switchToNewCityVC() {
        let vc = VCNewCity()
        self.navigationController?.pushViewController(vc, animated: true)

        vc.blockOnCitySelected = {
            (cityModel: CityModel) in
            CDCitiesStorage.sharedInstance.addCity(cityModel: cityModel)
        }
    }


}
