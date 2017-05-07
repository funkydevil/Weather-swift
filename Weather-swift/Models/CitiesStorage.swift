//
// Created by Kirill Pyulzyu on 26.04.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import Foundation




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
