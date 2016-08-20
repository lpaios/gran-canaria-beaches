//
//  SettingsTableViewController.swift
//  Playas
//
//  Created by Antonio Sejas on 20/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {
    
    enum Rows: Int { case developer = 1, contact, dataSource, login  }
    
    struct constants {
        //Rows
        static let developer = "https://sejas.es"
        static let contact = "grancanaria@sejas.es"
        static let dataSource = "http://opendatacanarias.es/"
        //Email
        static let emailSubject = "[Contact][GCBeaches] "
        //Segue
        static let segueToWeb = "toWeb"
        static let segueToLogin = "toLogin"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let tagInt = tableView.cellForRowAtIndexPath(indexPath)?.tag,
            let tag = Rows(rawValue: tagInt) {
            switch tag {
                case Rows.contact:
                    openMail(constants.contact)
                break
                case Rows.developer:
                    openWeb(constants.developer)
                break
                case Rows.dataSource:
                    openWeb(constants.dataSource)
                break
                case Rows.login:
                    performSegueWithIdentifier(constants.segueToLogin, sender: nil)
                break
            }
        }
    }
    
    func openWeb(url: String) {
//        if let url = NSURL(string: url) {
//            if UIApplication.sharedApplication().canOpenURL(url) {
//                UIApplication.sharedApplication().openURL(url)
//            }
//        }
        performSegueWithIdentifier(constants.segueToWeb, sender: url)
    }
    func openMail(email:String) {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject(constants.emailSubject)
        mailComposerVC.setMessageBody("", isHTML: false)
        self.presentViewController(mailComposerVC, animated: true, completion: nil)
    }
    // Mark: MAILCOMPOSE DELEGATE
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        guard error == nil else {
            print("Error \(error)")
            return
        }
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: SEGUE
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if constants.segueToWeb == segue.identifier,
            let urlString = sender as? String,
            let vc = segue.destinationViewController as? WebViewController {
            vc.urlString = urlString
        }
    }
    
}
