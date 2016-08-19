//
//  TitleLabel.swift
//  Playas
//
//  Created by Antonio Sejas on 19/8/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setShadow()
    }
    
    func setShadow() {
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 0.5;
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        self.font = UIFont(name: self.font.familyName, size: 24.0)
    }

}
