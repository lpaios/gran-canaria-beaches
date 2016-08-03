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

    var beach:Beach?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let beach = beach {
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
}
