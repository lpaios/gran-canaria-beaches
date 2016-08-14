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

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lbl_t_maxima: UILabel!
    @IBOutlet weak var lbl_t_water: UILabel!
    @IBOutlet weak var lbl_uv: UILabel!
    
    var beach:Beach?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let beach = beach {
            lblTitle.text = beach.name
            
            if beach.predictions.count > 0 {
                lbl_t_maxima.text = "\(beach.predictions[0].max_temperature)°C"
                lbl_t_water.text = "\(beach.predictions[0].water_temperature)°C"
                lbl_uv.text = beach.predictions[0].uv
            }
            
            StreetMap.getStreetMap(Int(img.frame.width), sizey: Int(img.frame.height), coordinate: beach.coordinate, completionHandlerForGETData: { (image, data, error) in
            guard error == nil else {
                print("error getStreetMap: ",error)
                return
            }
            performUIUpdatesOnMain({ 
                self.img.image = image
            })
         })
        }
    }
    
    //Close
    @IBAction func actionClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
}
