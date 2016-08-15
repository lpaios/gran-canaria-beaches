//
//  BeachesNetwork.swift
//  Playas
//
//  Created by Antonio Sejas on 1/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import CoreData

class BeachesNetwork: NSObject {
    // MARK: Shared Instance Singleton
    static let sharedInstance = BeachesNetwork()
    
    var beaches = [Beach]()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.stack.context
    }
    
    func getCachedLocations() -> [Beach] {
        return beaches
    }
    func downloadLocationsWithCompletion(completionHandler:(beaches: [Beach], error: NSError? ) -> Void) {
        let beachesCoreData = self.fetchCoreDataBeaches()
        if beachesCoreData.count > 0 {
            print("beachesCoreData.count: \(beachesCoreData.count)")
            self.beaches = beachesCoreData
            completionHandler(beaches: beaches, error: nil)
            return
        }
        
        
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
                beaches.append(Beach(dictionary: beachDictionary, context: self.sharedContext))
            }
            
            CoreDataStackManager.sharedInstance.stack.save()
            
            self.beaches = beaches
            completionHandler(beaches: beaches, error: nil)

            
        }
    }
    
    //READ FROM JSON FILE
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
                beaches.append(Beach(dictionary: beachDictionary, context: self.sharedContext))
            }
            
            self.beaches = beaches
            completionHandler(beaches: beaches, error: nil)
        }

    }
    
    
    
    //MARK: - Core Data Fetch Places
    func fetchCoreDataBeaches() -> [Beach] {
        let error: NSError? = nil
        
        var results: [AnyObject]?
        let fetchRequest = NSFetchRequest(entityName: "Beach")
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        } catch _ {
            results = nil
        }
        
        if error != nil {
            print("Can not access previous locations")
        }
        return results as! [Beach]
    }
}
