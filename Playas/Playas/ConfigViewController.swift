//
//  ConfigViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 10/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ConfigViewController: UIViewController {

    @IBAction func actionFacebookLogin(sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled { print("Facebook login was cancelled.")
            } else {
                print("You’re inz ;)")
            }
        });
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
