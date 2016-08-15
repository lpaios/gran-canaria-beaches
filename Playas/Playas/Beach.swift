//
//  Place.swift
//  Playas
//
//  Created by Antonio Sejas on 1/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class Beach: NSManagedObject, MKAnnotation {
    
    @NSManaged var name: String
    @NSManaged var text: String
    @NSManaged var id: Int
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    
    var predictions: [Prediction] = []
    
    struct constants {
        static let name = "dc:title"
        static let latitude = "geo:long"
        static let longitude = "geo:lat"
        static let id = "dc:identifier"
        static let text = "dc:description"
        
        static let aemet = "amet"
        static let prediction = "prediccion"
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
        super.init()
        guard
            let lat = Double(dictionary[constants.latitude] as! String),
            let long = Double(dictionary[constants.longitude] as! String) else {
                return
        }
        
        //Lat and long are inverted, beacuse there are an error in open data canarias
        self.latitude = long
        self.longitude = lat
        
    
        guard let name = dictionary[constants.name] as? String,
            let id = Int(dictionary[constants.id] as! String),
            let text = dictionary[constants.text] as? String else {
                return
        }
        self.name = name
        self.text = text
        self.id = id
        
        //Parse Prediction
        if let aemet = dictionary[constants.aemet],
        let predictionArray = aemet[constants.prediction] as? [AnyObject]  {
            for prediction in predictionArray {
                if let predictionDictionary = prediction as? [String:AnyObject] {
                    self.predictions.append(Prediction(dictionary: predictionDictionary))
                }
            }
        }
    }
    
}

//MARK: == Operator
// isEqual
func ==(lhs: Beach, rhs: Beach) -> Bool {
    return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude) && (lhs.name == rhs.name)
}