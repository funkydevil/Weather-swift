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
    
    func getAllCities()->[CDCity]{
        let request = CDCity.sortedFetchRequest
        var arrCDCitites = try! self.container!.viewContext.execute(request)
        return []
    }
    
    func addCity(cityModel:CityModel)->CDCity{
        //let cdC = self.container!.viewContext.insertObj()
        let cdCity:CDCity = self.container!.viewContext.insertObj()
        cdCity.name = cityModel.name!
        cdCity.id = cityModel.id!
        try! self.container!.viewContext.save()
        return cdCity
    }


    func deleteCity(cdCity:CDCity){
        self.container!.viewContext.delete(cdCity)
    }


}
