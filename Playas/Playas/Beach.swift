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
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
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
        //TODO: Create object from dictionary
    }
    
}

//MARK: == Operator
// isEqual
func ==(lhs: Beach, rhs: Beach) -> Bool {
    return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude) && (lhs.name == rhs.name)
}