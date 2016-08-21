//
//  MapViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 1/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    struct defaultCenterMap {
        static var center = CLLocationCoordinate2D(latitude: 27.986535941266062, longitude: -15.59603238693189)
        static var span = MKCoordinateSpan(latitudeDelta: 0.7236648091081932, longitudeDelta: 0.50865678413288151)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapLastViewed()
        
    }
    override func viewWillAppear(animated: Bool) {
        //We refresh in will appear , because list tab can refresh all the beaches
        fetchPlaces()
    }
    
    //MAP
    func updateLocationsMap() {
        //Delete old annotations if there were some
        performUIUpdatesOnMain({
            self.map.removeAnnotations(self.map.annotations)
        })
        
        performUIUpdatesOnMain({
            // When the array is complete, we add the annotations to the map.
            self.map.addAnnotations(BeachesNetwork.sharedInstance.beaches)
        })
    }
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Beach {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
                view.animatesDrop = true
                view.draggable = false
                
            }
            return view
        }
        return nil
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped tapped and annotation",view)
    }
    
    
    //Segue
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        print("tapped and annotation",view)
        self.map.deselectAnnotation(view.annotation, animated: false)
        let beach = view.annotation as! Beach
        performSegueWithIdentifier("goToDetail", sender: beach)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ("goToDetail" == segue.identifier!) {
            let v = segue.destinationViewController as! DetailViewController
            v.beach = sender as? Beach
        }
    }
    
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        UserDefaults.sharedInstance.saveCenterCoordinates(mapView.centerCoordinate)
        UserDefaults.sharedInstance.saveSpanCoordinates(mapView.region.span)
    }
    
    func centerMapLastViewed(){
        //First time we run the app or the map was not moved yet
        //Center in Gran canaria island
        if nil == UserDefaults.sharedInstance.getCenterCoordinates() {
            UserDefaults.sharedInstance.saveCenterCoordinates(defaultCenterMap.center)
            UserDefaults.sharedInstance.saveSpanCoordinates(defaultCenterMap.span)
        }
        //Show the last place you were viewing
        if let savedRegion = UserDefaults.sharedInstance.getCenterCoordinates() {
            map.setRegion(savedRegion, animated: false)
            print(savedRegion)
        }
    }
    
    
    //MARK: Gestures
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Network
    func fetchPlaces() {
        SpinnerView.sharedInstance.showLoading(self)
        BeachesNetwork.sharedInstance.downloadLocationsWithCompletionTryingCoreData { (beaches, error) in
            //We don't need to save beaches because we use it directly.
            performUIUpdatesOnMain({ 
                SpinnerView.sharedInstance.removeLoading(self)
            })
            guard nil == error else {
                CustomAlert.showError(self, title: "Error downloading beaches", message: "Error in request")
                return()
            }
            self.updateLocationsMap()
        }
    }

}
