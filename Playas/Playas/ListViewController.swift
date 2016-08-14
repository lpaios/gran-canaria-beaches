//
//  ListViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 7/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    struct constants {
        static let segueDetail = "goToDetail"
        static let beachCell = "beachCell"
    }

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPlaces()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("BeachesNetwork.sharedInstance.beaches.count\(BeachesNetwork.sharedInstance.beaches.count)")
        return BeachesNetwork.sharedInstance.beaches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier(constants.beachCell) as! BeachTableViewCell
        cell.lblTitle.text = BeachesNetwork.sharedInstance.beaches[indexPath.row].name
        print("cell.lblTitle.text\(cell.lblTitle.text)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier(constants.segueDetail, sender: BeachesNetwork.sharedInstance.beaches[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (constants.segueDetail == segue.identifier!) {
            let v = segue.destinationViewController as! DetailViewController
            v.beach = sender as? Beach
        }
    }

    
    //MARK: - Network
    func fetchPlaces() {
        BeachesNetwork.sharedInstance.downloadLocationsWithCompletion { (beaches, error) in
            //We don't need to save beaches because we use it directly.
            guard nil == error else {
                //TODO. Show error
                CustomAlert.sharedInstance.showError(self, title: "Error downloading beaches", message: "Error in request")
                return()
            }
            performUIUpdatesOnMain({ 
                self.table.reloadData()
            })
        }
    }
}
