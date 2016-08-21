//
//  userDefaults.swift
//  tourist-planner
//
//  Created by Antonio Sejas on 27/7/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import MapKit

class UserDefaults: NSObject {
    //MARK - Singleton
    static let sharedInstance = UserDefaults()
    
    struct Constants {
        // MARK: Preferences keys MAP
        static let centerCoordinateLat: String = "mapCenterCoordinateLat"
        static let centerCoordinateLong: String = "mapCenterCoordinateLong"
        
        static let spanCoordinateLat: String = "mapSpanCoordinateLat"
        static let spanCoordinateLong: String = "mapSpanCoordinateLong"
        
        //Mark: Preferences keys Show description
        static let showDescription: String = "showDescription"
        
    }
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    //Mark: Map Center
    func saveCenterCoordinates(coordinates: CLLocationCoordinate2D)  {
        prefs.setObject(NSNumber(double: coordinates.latitude), forKey: Constants.centerCoordinateLat)
        prefs.setObject(NSNumber(double: coordinates.longitude), forKey: Constants.centerCoordinateLong)
    }
    func saveSpanCoordinates(coordinates: MKCoordinateSpan)  {
        prefs.setObject(NSNumber(double: coordinates.latitudeDelta), forKey: Constants.spanCoordinateLat)
        prefs.setObject(NSNumber(double: coordinates.longitudeDelta), forKey: Constants.spanCoordinateLong)
    }
    func getCenterCoordinates() -> MKCoordinateRegion? {
        guard let lat = prefs.objectForKey(Constants.centerCoordinateLat),
            let long = prefs.objectForKey(Constants.centerCoordinateLong),
            let latSpan = prefs.objectForKey(Constants.spanCoordinateLat),
            let longSpan = prefs.objectForKey(Constants.spanCoordinateLong) else {
                return nil
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat.doubleValue, longitude:long.doubleValue), span: MKCoordinateSpan(latitudeDelta: latSpan.doubleValue, longitudeDelta: longSpan.doubleValue))
    }
    //Mark: ShowDescription
    func saveShowDescription(showDescription: Bool)  {
        prefs.setBool(showDescription, forKey: Constants.showDescription)
    }
    func getShowDescription() -> Bool  {
        if nil == prefs.objectForKey(Constants.showDescription) {
            //If doesn't exist, we init show description to true
            self.saveShowDescription(true)
            return true
        }
        return prefs.boolForKey(Constants.showDescription)
    }
}
