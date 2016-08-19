//
//  DetailViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 3/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var lblTitle: TitleLabel!
    
    @IBOutlet weak var lbl_t_maxima: UILabel!
    @IBOutlet weak var lbl_t_water: UILabel!
    @IBOutlet weak var lbl_uv: UILabel!
    
    var beach:Beach?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let beach = beach {
            lblTitle.text = beach.name
            
            if beach.predictions.count > 0,
                let prediction = beach.predictions[0] as? Prediction{
                lbl_t_maxima.text = "\(prediction.max_temperature)°C"
                lbl_t_water.text = "\(prediction.water_temperature)°C"
                lbl_uv.text = prediction.uv
            }
            
            showImage(beach)
        }
    }
    
    func showImage(beach: Beach) {
        if let imageData = beach.img {
            performUIUpdatesOnMain({
                self.img.image = UIImage(data: imageData)
            })
        }else{
            typealias CompletionBlock = (image: UIImage?, data: NSData, error: NSError?) -> Void
            let completeAfterDownloadImage: CompletionBlock = { image, data, error in
                guard error == nil else {
                    print("error getStreetMap: ",error)
                    return
                }
                performUIUpdatesOnMain({
                    self.img.image = image
                })
                beach.img = data
                CoreDataStackManager.sharedInstance.stack.save()
            }
            if "" == beach.url_image {
                //Download image from Goolge StreetMaps
                StreetMap.getStreetMap(Int(img.frame.width), sizey: Int(img.frame.height), coordinate: beach.coordinate, completionHandlerForGETData: completeAfterDownloadImage)
            }else{
                NetworkHelper.sharedInstance.getImage(beach.url_image, completionHandlerForGETData: completeAfterDownloadImage)
            }
        }
    }
    
    //Close
    @IBAction func actionClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
}
