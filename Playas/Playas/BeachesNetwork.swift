//
//  BeachesNetwork.swift
//  Playas
//
//  Created by Antonio Sejas on 1/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class BeachesNetwork: NSObject {
    // MARK: Shared Instance Singleton
    static let sharedInstance = BeachesNetwork()
    
    var beaches = [Beach]()
    
    func getCachedLocations() -> [Beach] {
        return beaches
    }
    func downloadLocationsWithCompletion(completionHandler:(beaches: [Beach], error: NSError? ) -> Void) {
        let urlString = "https://beaches-26a4e.firebaseio.com/grancanariabeaches/resources.json"
        NetworkHelper.sharedInstance.getRequest(urlString, headers: nil) { (result, error) in
            guard nil == error else {
                print ("error")
                completionHandler(beaches: [Beach](), error: error)
                return
            }
             var beaches = [Beach]()
            guard let beachesDictionary = result as? [[String:AnyObject]] else {
                completionHandler(beaches: [Beach](), error: NSError(domain: "downloadLocationsWithCompletion", code: 0, userInfo: nil))
                return
            }
            print("beachesDictionary",beachesDictionary)
            for beachDictionary in beachesDictionary {
                beaches.append(Beach(dictionary: beachDictionary))
            }
            
            self.beaches = beaches
            completionHandler(beaches: beaches, error: nil)

            
        }
    }
    func readLocalLocationsWithCompletion(completionHandler:(beaches: [Beach], error: NSError? ) -> Void) {
//        let url = NSBundle.mainBundle().URLForResource("playas-gran-canaria", withExtension: "json")!
        let urlString = NSBundle.mainBundle().pathForResource("playas-gran-canaria", ofType: "json")
        print("url string: ",urlString)
//        let urlString = url.absoluteString //"playas-gran-canaria.json" //
        NetworkHelper.sharedInstance.getLocalRequest(urlString!) { (result, error) in
            guard nil == error else {
                print ("error")
                completionHandler(beaches: [Beach](), error: error)
                return
            }
            var beaches = [Beach]()
            guard let beachesDictionary = result["resources"] as? [[String:AnyObject]] else {
                completionHandler(beaches: [Beach](), error: NSError(domain: "downloadLocationsWithCompletion", code: 0, userInfo: nil))
                return
            }
            print("beachesDictionary",beachesDictionary)
            for beachDictionary in beachesDictionary {
                beaches.append(Beach(dictionary: beachDictionary))
            }
            
            self.beaches = beaches
            completionHandler(beaches: beaches, error: nil)
        }

    }
}
