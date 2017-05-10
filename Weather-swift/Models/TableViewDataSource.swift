//
// Created by Kirill Pyulzyu on 10.05.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import UIKit
import CoreData

protocol TableViewDataSourceDelegate: class {
    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UITableViewCell
    func configure(_ cell: Cell, for object: Object)
}


class TableViewDataSource<Delegate:TableViewDataSourceDelegate>:NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell

    /////
    let fetchedResultsController:NSFetchedResultsController<Object>
    let tableView:UITableView
    let cellIdentifier:String
    let delegate:Delegate
    ////

    required init(tableView:UITableView, cellIdentifier:String, fetchedResultsController:NSFetchedResultsController<Object>,
                  delegate:Delegate){
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate

        super.init()

        fetchedResultsController.delegate = nil
        try! fetchedResultsController.performFetch()
        tableView.dataSource = self
        tableView.reloadData()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section]
                else {
            return 0
        }

        return section.numberOfObjects
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath) as? Cell
                else {fatalError("Unexpected cell type at \(indexPath)")}

        self.delegate.configure(cell, for: object)

        return cell
    }

}
