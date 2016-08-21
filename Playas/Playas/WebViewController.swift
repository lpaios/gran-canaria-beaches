//
//  WebViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 20/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var web: UIWebView!
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        
        web.delegate = self
        if let url = NSURL (string: urlString) {
            let request = NSURLRequest(URL: url)
            web.loadRequest(request);
        }
       
    }
    override func viewWillDisappear(animated: Bool) {
        SpinnerView.sharedInstance.removeLoading(self)
    }
    
    //Mark: Delegate WebView
    func webViewDidStartLoad(webView: UIWebView) {
        SpinnerView.sharedInstance.showLoading(self)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SpinnerView.sharedInstance.removeLoading(self)
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if let error = error {
                CustomAlert.showError(self, title: "Error loading web", message: error.localizedDescription)
                SpinnerView.sharedInstance.removeLoading(self)
        }
    }
    
    
    

}
