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

    func onBtnAddTapped(_ sender: UIBarButtonItem) {
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
        let cdCity = self.fetchResultsController.object(at: indexPath) as! CDCity
        self.switchToCityDetails(cdCity: cdCity)
    }




//    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }


    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let cdCity = self.fetchResultsController.object(at: indexPath) as? CDCity
            CDCitiesStorage.sharedInstance.deleteCity(cdCity: cdCity!)
            try! CDCitiesStorage.sharedInstance.container!.viewContext.save()

        case .insert:
            print("insert")

        case .none:
            print("none")
        }
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

    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {
                fatalError("Index path sould be not nil")
            }
            tableView.insertRows(at: [indexPath], with: .automatic)

        case .delete:
            guard let indexPath = indexPath else {
                fatalError("Index path sould be not nil")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)

        default:
            break;

        }
    }




    //MARK: segues

    func switchToNewCityVC() {
        let vc = VCNewCity()
        self.navigationController?.pushViewController(vc, animated: true)

        vc.blockOnCitySelected = {
            (cityModel: CityModel) in
            _ = CDCitiesStorage.sharedInstance.addCity(cityModel: cityModel)
        }
    }

    func switchToCityDetails(cdCity:CDCity)
    {
        let vc = VCCityDetails(cdCity: cdCity)
        self.navigationController!.pushViewController(vc, animated: true)
    }


}
