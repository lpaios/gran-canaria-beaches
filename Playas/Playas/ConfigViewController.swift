//
//  ConfigViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 10/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ConfigViewController: UIViewController {

    @IBOutlet weak var stackLogged: UIStackView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var stackNotLogged: UIStackView!
    @IBAction func actionFacebookLogin(sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        print("Logging In")
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler:{(facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
                
            } else {
                print("Login")
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    guard error == nil ,
                        let user = user else {
                            print("ERROR  FIRAuth.auth()?.signInWithCredential")
                        return
                    }
                    self.isLogged(user)
                }
                
            }
        });
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func isLogged(user:FIRUser) {
        performUIUpdatesOnMain { 
            self.stackLogged.hidden = false
            self.stackNotLogged.hidden = true
            self.lblName.text = user.displayName
        }
        NetworkHelper.sharedInstance.getImage((user.photoURL?.absoluteString)!) { (image, data, error) in
            guard error == nil else {
                
                return
            }
            performUIUpdatesOnMain({
                self.imgUser.image = image
            })
        }
        
    }
    func notLogged() {
        performUIUpdatesOnMain { 
            self.stackLogged.hidden = true
            self.stackNotLogged.hidden = false
        }
    }
    override func viewWillAppear(animated: Bool) {
        FirebaseHelper.sharedInstance.getCurrentUser(isLogged,notLogged: notLogged)
    }
    
    

}
