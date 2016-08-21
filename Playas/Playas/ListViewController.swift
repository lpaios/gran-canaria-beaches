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
        static let imgPlaceHolderName = "beach-placeholder"
    }

    @IBOutlet weak var table: UITableView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefresh()
        fetchPlaces()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeachesNetwork.sharedInstance.beaches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier(constants.beachCell) as! BeachTableViewCell
        let beach = BeachesNetwork.sharedInstance.beaches[indexPath.row]
        cell.lblTitle.text = beach.name
        print("cell.lblTitle.text\(cell.lblTitle.text)")
        //If image in cache
        //if photoFlickr.image != nil {
        if let imageData = beach.img {
            cell.img.image = UIImage(data: imageData)
        }else{
            setImageHolderAndDownloadImage(cell, beach: beach)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier(constants.segueDetail, sender: BeachesNetwork.sharedInstance.beaches[indexPath.row])
    }
    
    
    func setImageHolderAndDownloadImage(cell:BeachTableViewCell, beach: Beach) {
        performUIUpdatesOnMain({
            cell.img.image = UIImage(named: constants.imgPlaceHolderName)
            cell.startAnimating()
        })
        typealias CompletionBlock = (image: UIImage?, data: NSData, error: NSError?) -> Void
        let completeAfterDownloadImage: CompletionBlock = { image, data, error in
            performUIUpdatesOnMain({ 
                cell.stopAnimating()
            })
            guard error == nil else {
                print("error getStreetMap: ",error)
                cell.img.image = UIImage(named: constants.imgPlaceHolderName)
                return
            }
            performUIUpdatesOnMain({
                beach.img = data
                cell.img.image = image
            })
            CoreDataStackManager.sharedInstance.stack.save()
        }
        if "" == beach.url_image {
            //Download image from Goolge StreetMaps
            StreetMap.getStreetMap(Int(cell.frame.width), sizey: Int(cell.frame.height), coordinate: beach.coordinate, completionHandlerForGETData: completeAfterDownloadImage)
        }else{
            NetworkHelper.sharedInstance.getImage(beach.url_image, completionHandlerForGETData: completeAfterDownloadImage)
        }
    }

    
    
    
    //MARK: segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (constants.segueDetail == segue.identifier!) {
            let v = segue.destinationViewController as! DetailViewController
            v.beach = sender as? Beach
        }
    }
    
    //MARK: Refresh
    func setRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        table.addSubview(refreshControl) // not required when using UITableViewController
    }
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        if Reachability.isConnectedToNetwork() == true {
            deleteAndFetchPlaces()
        } else {
            CustomAlert.showError(self, title: "No internet", message: "It seems that you don't have internet connection")
            refreshControl.endRefreshing()
        }
    }

    
    //MARK: - Network and coredata
    func completionAfterFetch(beaches: [Beach], error: NSError?) {
        //We don't need to save beaches because we use it directly.
        performUIUpdatesOnMain{
            SpinnerView.sharedInstance.removeLoading(self)
        }
        guard nil == error else {
            //TODO. Show error
            CustomAlert.showError(self, title: "Error downloading beaches", message: "Error in request")
            performUIUpdatesOnMain({
                self.refreshControl.endRefreshing()
            })
            return()
        }
        performUIUpdatesOnMain({
            self.table.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    func deleteAndFetchPlaces() {
        SpinnerView.sharedInstance.showLoading(self)
        BeachesNetwork.sharedInstance.downloadLocationsWithCompletion(completionAfterFetch)
    }

    func fetchPlaces() {
        SpinnerView.sharedInstance.showLoading(self)
        BeachesNetwork.sharedInstance.downloadLocationsWithCompletionTryingCoreData(completionAfterFetch)
    }
}
