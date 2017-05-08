//
//  ManagedProtocol.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 08.05.17.
//  Copyright © 2017 Kirill Pyulzyu. All rights reserved.
//

import CoreData

protocol Managed: class, NSFetchRequestResult {
    static var entityName:String{get}
    static var defaultSortDescriptor:[NSSortDescriptor]{get}
}

extension Managed where Self:NSManagedObject{
    static var entityName:String{
        return entity().name!
    }

    static var defaultSortDescriptors:[NSSortDescriptor]{
        return []
    }
    
    static var sortedFetchRequest:NSFetchRequest<Self>{
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptor
        return request
    }
}

