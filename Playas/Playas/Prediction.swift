//
//  Prediction.swift
//  Playas
//
//  Created by Antonio Sejas on 11/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class Prediction: NSObject {
    
    struct constants {
        static let sky = "estado_cielo"
        static let waves = "oleaje"
        static let date = "fecha"
        static let water_temperature = "t_agua"
        static let max_temperature = "t_maxima"
        static let uv = "uv_max"
        static let wind = "viento"
        
        static let description1 = "descripcion1"
        static let description2 = "descripcion2"
        static let f1 = "f1"
        static let f2 = "f2"
        static let value = "valor1"
    }
    
    struct oneDetail {
        var f1:String
        var description1:String
    }
    struct twoDetails {
        var f1:String
        var description1:String
        var f2:String
        var description2:String
    }
    
    var sky = twoDetails(f1: "", description1: "", f2: "", description2: "")
    var waves = twoDetails(f1: "", description1: "", f2: "", description2: "")
    var wind = twoDetails(f1: "", description1: "", f2: "", description2: "")
    var date = ""
    var temp_sensation = oneDetail(f1: "", description1: "")
    var water_temperature = ""
    var max_temperature = ""
    var uv = ""
    
    init(dictionary: [String : AnyObject]) {
        super.init()
        if let sky = dictionary[constants.sky],
            let desc1 = sky[constants.description1] as? String,
            let desc2 = sky[constants.description2] as? String,
            let f1 = sky[constants.f1] as? String,
            let f2 = sky[constants.f2] as? String
        {
            self.sky = twoDetails(f1: f1, description1: desc1, f2: f2, description2: desc2)
        }
        
        if let partial = dictionary[constants.waves],
            let desc1 = partial[constants.description1] as? String,
            let desc2 = partial[constants.description2] as? String,
            let f1 = partial[constants.f1] as? String,
            let f2 = partial[constants.f2] as? String
        {
            self.waves = twoDetails(f1: f1, description1: desc1, f2: f2, description2: desc2)
        }
        
        if let partial = dictionary[constants.wind],
            let desc1 = partial[constants.description1] as? String,
            let desc2 = partial[constants.description2] as? String,
            let f1 = partial[constants.f1] as? String,
            let f2 = partial[constants.f2] as? String
        {
            self.wind = twoDetails(f1: f1, description1: desc1, f2: f2, description2: desc2)
        }
        if let partial = dictionary[constants.wind],
            let desc1 = partial[constants.description1] as? String,
            let f1 = partial[constants.f1] as? String
        {
            self.temp_sensation = oneDetail(f1: f1, description1: desc1)
        }
        
        if let partial = dictionary[constants.uv] as? String {
            self.uv = partial
        }
        
        if let partial = dictionary[constants.date] as? String {
            self.date = partial
        }
        
        if let partial = dictionary[constants.water_temperature] as? String {
            self.water_temperature = partial
        }
        
        if let partial = dictionary[constants.max_temperature] as? String {
            self.max_temperature = partial
        }
        
        
    }
}
