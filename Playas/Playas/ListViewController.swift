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
        })
        typealias CompletionBlock = (image: UIImage?, data: NSData, error: NSError?) -> Void
        let completeAfterDownloadImage: CompletionBlock = { image, data, error in
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
