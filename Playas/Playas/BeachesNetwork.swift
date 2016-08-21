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
    
    struct constants {
        static let beachesFirebaseUrl = "https://beaches-26a4e.firebaseio.com/grancanariabeaches/resources.json"
    }
    
    // Mark: - Fetched Results Controller
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Beach")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    // If beaches and coredata is empty then it download the beaches from network, just if coredata is empty
    func downloadLocationsWithCompletionTryingCoreData(completionHandler:(beaches: [Beach], error: NSError? ) -> Void) {
        //ORDERED BY NAME
        let beachesCoreData = self.fetchCoreDataBeachesOrdered()
        if beachesCoreData.count > 0 {
            print("beachesCoreData.count: \(beachesCoreData.count)")
            self.beaches = beachesCoreData
            completionHandler(beaches: beaches, error: nil)
            return
        }
        downloadLocationsWithCompletion(completionHandler)
    }
    //delete and download all beaches
    func downloadLocationsWithCompletion(completionHandler:(beaches: [Beach], error: NSError? ) -> Void) {
        NetworkHelper.sharedInstance.getRequest(constants.beachesFirebaseUrl, headers: nil) { (result, error) in
            guard nil == error else {
                print ("error")
                completionHandler(beaches: [Beach](), error: error)
                return
            }
            
            BeachesNetwork.sharedInstance.deleteBeaches()
            var beaches = [Beach]()
            guard let beachesDictionary = result as? [[String:AnyObject]] else {
                completionHandler(beaches: [Beach](), error: NSError(domain: "downloadLocationsWithCompletion", code: 0, userInfo: nil))
                return
            }
            print("beachesDictionary",beachesDictionary)
            for beachDictionary in beachesDictionary {
                beaches.append(Beach(dictionary: beachDictionary, context: self.sharedContext))
            }
            //ORDER BY NAME
            beaches.sortInPlace { (b1, b2) -> Bool in
                return b1.name < b2.name
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
    
    
    func deleteBeaches() {
        for beach in beaches {
            sharedContext.deleteObject(beach)
        }
        CoreDataStackManager.sharedInstance.stack.save()
        beaches = []
    }
    
    
    
    //MARK: - Core Data Fetch Beaches
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
    // MARK: Core Data Fetch Beaches ordered
    func fetchCoreDataBeachesOrdered() -> [Beach] {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error performing fetch \(error)")
        }
        print("fetchCoreDataBeachesOrdered count fetchedResultsController.fetchedObjects?.count \(fetchedResultsController.fetchedObjects?.count)")
        return fetchedResultsController.fetchedObjects as! [Beach]
        
    }
}
