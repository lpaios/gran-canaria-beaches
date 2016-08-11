//
//  FirebaseHelper.swift
//  Playas
//
//  Created by Antonio Sejas on 10/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import Firebase
class FirebaseHelper: NSObject {
    // MARK: Shared Instance Singleton
    static let sharedInstance = FirebaseHelper()
//    let ref = Firebase(url: "https://<YOUR-FIREBASE-APP>.firebaseio.com")
    var user:FIRUser? = nil
    func getCurrentUser(isLogged:(user:FIRUser)->Void, notLogged:()->Void){
        if let user = self.user {
            isLogged(user: user)
            return
        }
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                self.user = user
                print("getCurrentUser user: \(user)")
                isLogged(user: user)
            } else {
                // No user is signed in.
                print("getCurrentUser not user")
                notLogged()
            }
        }
    }
    
}
