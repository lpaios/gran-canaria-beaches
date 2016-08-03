//
//  StreetMap.swift
//  Playas
//
//  Created by Antonio Sejas on 3/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import MapKit

//URL EJEMPLO
//https://maps.googleapis.com/maps/api/streetview?size=400x400&location=40.720032,-73.988354&fov=90&heading=235&pitch=10&key=
class StreetMap: NSObject {
    
    static func getStreetMap(sizex:Int, sizey:Int, coordinate: CLLocationCoordinate2D, completionHandlerForGETData:(image: UIImage, data: NSData, error: NSError?) -> Void ){
        let urlString = "https://maps.googleapis.com/maps/api/streetview?size=\(sizex)x\(sizey)&location=\(coordinate.latitude),\(coordinate.longitude)&fov=90&heading=235&pitch=10&key="
        
        NetworkHelper.sharedInstance.getImage(urlString, completionHandlerForGETData: completionHandlerForGETData)
    }
}
