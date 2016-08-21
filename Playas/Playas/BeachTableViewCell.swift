//
//  BeachTableViewCell.swift
//  Playas
//
//  Created by Antonio Sejas on 7/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class BeachTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.activity.hidden = true
    }
    
    func startAnimating() {
        self.activity.startAnimating()
        self.activity.hidden = false
    }
    func stopAnimating() {
        self.activity?.stopAnimating()
        self.activity.hidden = true
    }

}
