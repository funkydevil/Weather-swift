//
// Created by Kirill Pyulzyu on 08.05.17.
// Copyright (c) 2017 Kirill Pyulzyu. All rights reserved.
//

import Foundation

struct WeatherItemModel {
    let tempMin: Float?
    let tempMax: Float?
    let date: TimeInterval?

    init(remoteDict: Dictionary<String, Any>) {
        if let main = remoteDict["main"] as! Dictionary<String, Any>?,
           let tempMin = main["temp_min"] as! Float?,
           let tempMax = main["temp_max"] as! Float?,
           let date = remoteDict["dt"] as! TimeInterval? {
            self.tempMin = tempMin
            self.tempMax = tempMax
            self.date = date
        } else {
            self.tempMin = nil
            self.tempMax = nil
            self.date = nil
        }
    }
}