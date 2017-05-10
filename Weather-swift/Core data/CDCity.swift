//
//  CDCity.swift
//  Weather-swift
//
//  Created by Kirill Pyulzyu on 08.05.17.
//  Copyright © 2017 Kirill Pyulzyu. All rights reserved.
//

import Foundation
import CoreData

public class CDCity:NSManagedObject{
    @NSManaged public  var name:String
    @NSManaged public  var id:Int
}

