//
//  ManagedProtocol.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 08.05.17.
//  Copyright © 2017 Kirill Pyulzyu. All rights reserved.
//

import CoreData


extension NSManagedObject {
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }

    public static var entityName: String {
        return entity().name!
    }

    public static var sortedFetchRequest: NSFetchRequest<NSManagedObject> {
        let name = entityName
        let request = NSFetchRequest<NSManagedObject>(entityName: name)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}



extension NSManagedObjectContext {
    func insertObj<A:NSManagedObject>() -> A  {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A
                else {
            fatalError("Wrong object type")
        }
        return obj
    }

    func deleteObj(obj:NSManagedObject){
        self.delete(obj)
    }
}
