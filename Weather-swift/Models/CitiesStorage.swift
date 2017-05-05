//
// Created by Kirill Pyulzyu on 26.04.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import Foundation

struct CityModel {
    let name: String?
    let id: Int?

    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }

    init(remoteDictCity: Dictionary<String, Any>) {

        if let name = remoteDictCity["name"] as! String?{
            self.name = name
        }
        else{
            self.name = nil
        }

        if let id = remoteDictCity["id"] as! Int?{
            self.id = id
        }
        else{
            self.id = nil
        }
    }
}


class CitiesStorage {

    static let sharedInstance = CitiesStorage()

    private var cities = [CityModel]()


    func addCity(cityModel: CityModel) {
        self.cities.append(cityModel)
    }


    func allCities() -> Array<CityModel> {
        return self.cities
    }


    func removeCity(cityModel: CityModel) {

    }

}
