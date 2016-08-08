//
//  ListViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 7/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPlaces()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeachesNetwork.sharedInstance.beaches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell() as! BeachTableViewCell
        cell.lblTitle.text = BeachesNetwork.sharedInstance.beaches[indexPath.row].name
        return cell
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
