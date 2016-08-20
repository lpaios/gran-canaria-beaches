//
//  WebViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 20/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var web: UIWebView!
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        if let url = NSURL (string: urlString) {
            let request = NSURLRequest(URL: url);
            web.loadRequest(request);
        }
       
    }

}
