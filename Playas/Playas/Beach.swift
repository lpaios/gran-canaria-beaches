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
    
    @NSManaged var predictions: NSMutableOrderedSet
    @NSManaged var name: String
    @NSManaged var text: String
    @NSManaged var id_beach: NSNumber
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var url_image: String
    @NSManaged var img: NSData?
    
    
//    var predictions: [Prediction] = []
    
    struct constants {
        static let coreDataEntityName = "Beach"
        
        static let name = "dc:title"
        static let latitude = "geo:long"
        static let longitude = "geo:lat"
        static let id_beach = "id_beach"
        static let text = "dc:description"
        
        static let url_image = "url_image"
        
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
    override init(entity: NSEntityDescription,
                  insertIntoManagedObjectContext
                  context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    init(coordinate: CLLocationCoordinate2D, name: String, context: NSManagedObjectContext) {
        // Core Data
        let entity = NSEntityDescription.entityForName(constants.coreDataEntityName,
                                                       inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        self.name = name
        predictions = NSMutableOrderedSet()
    }
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        // Core Data
        let entity = NSEntityDescription.entityForName(constants.coreDataEntityName,
                                                       inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        updateJustBeach(dictionary, context: context)
        predictions = NSMutableOrderedSet()
        addPredictions(dictionary, context: context)
    }
    
    func updateJustBeach (dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        guard let name = dictionary[constants.name] as? String,
            let id_beach = dictionary[constants.id_beach] as? Int,
            let text = dictionary[constants.text] as? String else {
                return
        }
        guard
            let lat = Double((dictionary[constants.latitude] as? String)!),
            let long = Double((dictionary[constants.longitude] as? String)!) else {
                return
        }
        self.name = name
        self.text = text
        self.id_beach = id_beach
        //Lat and long are inverted, beacuse there are an error in open data canarias
        self.latitude = long
        self.longitude = lat
        
        self.url_image = ""
        if let url_image = dictionary[constants.url_image] as? String  {
            self.url_image = url_image
        }

    }
    
    func addPredictions(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        //Parse Prediction
        if let aemet = dictionary[constants.aemet],
            let predictionArray = aemet[constants.prediction] as? [AnyObject]  {
            for prediction in predictionArray {
                if let predictionDictionary = prediction as? [String:AnyObject] {
                    let prediction = Prediction(dictionary: predictionDictionary, context: context)
                    prediction.beach = self
                    self.predictions.addObject(prediction)
                }
            }
        }
    }
    
    func updateBeachAndPredictions(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        //Update beache
        updateJustBeach(dictionary, context: context)
        //Delete all predictions
        for prediction in predictions  {
            if let prediction = prediction as? Prediction {
                context.deleteObject(prediction)
            }
        }
        addPredictions(dictionary, context: context)
        CoreDataStackManager.sharedInstance.stack.save()
    }
    
}

//MARK: == Operator
// isEqual
func ==(lhs: Beach, rhs: Beach) -> Bool {
    return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude) && (lhs.name == rhs.name) && (lhs.id_beach == rhs.id_beach)
}