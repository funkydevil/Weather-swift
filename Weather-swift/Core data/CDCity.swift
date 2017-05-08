//
//  CDCity.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 08.05.17.
//  Copyright © 2017 Kirill Pyulzyu. All rights reserved.
//

import Foundation
import CoreData

final class CDCity:NSManagedObject, Managed{
    @NSManaged fileprivate(set) var name:String
    @NSManaged fileprivate(set) var id:Int
    
}
