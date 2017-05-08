//
//  CDCitiesStoreage.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 08.05.17.
//  Copyright © 2017 Kirill Pyulzyu. All rights reserved.
//

import Foundation
import CoreData

class CDCitiesStorage{
    static let sharedInstance = CDCitiesStorage()
    var container:NSPersistentContainer?
    
    func initCD(completion:@escaping ()->()){
        self.createContainer { container in
            self.container = container
            completion()
        }
    }

    func createContainer (completion: @escaping(NSPersistentContainer)->()){
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores {
            (persistantStoreDesctiption:NSPersistentStoreDescription, error:Error?) in
            guard error == nil else {
                fatalError("Failed to load store:\(error.debugDescription)")
            }

            DispatchQueue.main.async {
                completion(container)
            }
        }
    }
    
    func getAllCities()->NSArray{
        let request = CDCity.sortedFetchRequest
        
        
    }
    
    

}
