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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var lbl_text: UILabel!
    var beach:Beach?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let beach = beach {
            lblTitle.text = beach.name
            
            if beach.predictions.count > 0,
                let prediction = beach.predictions[0] as? Prediction {
                if prediction.date == BauUtils.getYearMonthDay() {
                    showTodayPrediction(prediction)
                }else{
                    //if the date is not wright, then we refresh the prdictions for this beach
                    refreshBeachAndPredictions(beach)
                }
            }
            
            if UserDefaults.sharedInstance.getShowDescription() {
                lbl_text.text = beach.text
                lbl_text.lineBreakMode = .ByWordWrapping
                lbl_text.numberOfLines = 0
                lbl_text.sizeToFit()
                
                innerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: lbl_text.frame.height)
                print("innerviewframe \(innerView.frame.height)")
                self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0)
            }else{
                self.scrollView.hidden = true
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
            SpinnerView.sharedInstance.showLoading(self)
            typealias CompletionBlock = (image: UIImage?, data: NSData, error: NSError?) -> Void
            let completeAfterDownloadImage: CompletionBlock = { image, data, error in
                SpinnerView.sharedInstance.removeLoading(self)
                guard error == nil else {
                    print("error getStreetMap: ",error)
                    CustomAlert.showError(self, title: "Error downloading image", message: (error?.localizedDescription)!)
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
    
    func showTodayPrediction(prediction: Prediction) {
        lbl_t_maxima.text = "\(prediction.max_temperature)°C"
        lbl_t_water.text = "\(prediction.water_temperature)°C"
        lbl_uv.text = prediction.uv
    }
    
    func refreshBeachAndPredictions(beach: Beach) {
        SpinnerView.sharedInstance.showLoading(self)
        BeachesNetwork.sharedInstance.getOneBeach(beach.id_beach) { (beachDictionary, error) in
            performUIUpdatesOnMain({ 
                SpinnerView.sharedInstance.removeLoading(self)
            })
            guard error == nil else {
                CustomAlert.showError(self, title: "Network Error", message: "Sorry we cannot show you today temperatures")
                return
            }
            beach.updateBeachAndPredictions(beachDictionary, context: CoreDataStackManager.sharedInstance.stack.context)
            if let prediction = beach.predictions[0] as? Prediction {
                if prediction.date == BauUtils.getYearMonthDay() {
                    performUIUpdatesOnMain({
                        self.showTodayPrediction(prediction)
                    })
                }else{
                     CustomAlert.showError(self, title: "Sorry", message: "We cannot show you today temperatures")
                }
            }
        }
    }
    
    //Close
    @IBAction func actionClose(sender: AnyObject) {
        dismissViewControllerAnimated(true) {
            
        }
    }
}
