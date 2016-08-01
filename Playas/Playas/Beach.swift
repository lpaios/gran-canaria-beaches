//
//  Place.swift
//  Playas
//
//  Created by Antonio Sejas on 1/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import MapKit

class Beach: NSObject, MKAnnotation {
    var name = ""
    var text: String = ""
    var id: Int = -1
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    struct constants {
        static let name = "dc:title"
        static let latitude = "geo:long"
        static let longitude = "geo:lat"
        static let id = "dc:identifier"
        static let text = "dc:description"
    }
    
    // conform to MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
    }
    
    
    init(coordinate: CLLocationCoordinate2D, name: String) {
        super.init()
        
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        self.name = name
    }
    
    init(dictionary: [String : AnyObject]) {
        guard let lat = dictionary[constants.latitude] as? Double,
                let long = dictionary[constants.longitude] as? Double,
                let name = dictionary[constants.name] as? String,
                let id = dictionary[constants.id] as? Int,
            let text = dictionary[constants.text] as? String else {
        
                return
        }
        
        self.latitude = lat
        self.longitude = long
        self.text = text
        self.id = id
        self.name = name
    }
    
}

//MARK: == Operator
// isEqual
func ==(lhs: Beach, rhs: Beach) -> Bool {
    return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude) && (lhs.name == rhs.name)
}