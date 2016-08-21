//
//  SpinnerView.swift
//  Playas
//
//  Created by Antonio Sejas on 21/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class SpinnerView: UIView {
    static let sharedInstance = SpinnerView()
    
    
    struct constants {
        struct spinner {
            static let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            static let color = UIColor(white: 0, alpha: 0.75)
            static let radius:CGFloat = 5.0
            //inner
            static let center = CGPoint(x: 25, y: 25)
        }
    }
    
    // Mark: General Helpers
    func showLoading(that: UIViewController) {
        print("loading network")
        that.view.addSubview(spinnerWrapper)
        spinner.startAnimating()
        self.spinnerWrapper.hidden = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func removeLoading(that: UIViewController) {
        print("end network")
        that.view.willRemoveSubview(spinnerWrapper)
        spinner.stopAnimating()
        self.spinnerWrapper.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    var spinnerWrapper:UIView!
    var spinner:UIActivityIndicatorView!
    
    func isAnimating() -> Bool{
        return spinner.isAnimating()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height))
        spinnerWrapper = UIView(frame: constants.spinner.frame)
        spinnerWrapper.center = self.center
        spinnerWrapper.backgroundColor = constants.spinner.color
        spinnerWrapper.layer.cornerRadius = constants.spinner.radius
//        self.addSubview(spinnerWrapper)
        spinner = UIActivityIndicatorView(frame: constants.spinner.frame)
        spinner.center = constants.spinner.center
        spinner.activityIndicatorViewStyle = .White
        spinner.startAnimating()
        
        spinnerWrapper.addSubview(spinner)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spinnerWrapper = UIView(frame: constants.spinner.frame)
        spinnerWrapper.backgroundColor = constants.spinner.color
        spinnerWrapper.layer.cornerRadius = constants.spinner.radius
        //self.addSubview(spinnerWrapper)
        spinner = UIActivityIndicatorView(frame: constants.spinner.frame )
        spinner.center = constants.spinner.center
        spinner.activityIndicatorViewStyle = .White
        spinner.startAnimating()
        
        spinnerWrapper.addSubview(spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
