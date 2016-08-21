//
//  BauUtils.swift
//  tourist-planner
//
//  Created by Antonio Sejas on 5/6/16.
//  Copyright © 2016 Antonio Sejas. All rights reserved.
//

import UIKit

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}



class BauUtils {
    static func getYearMonthDay () -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        print("getYearMonthDay :\(formatter.stringFromDate(NSDate()))" )
        return formatter.stringFromDate(NSDate())
    }
}

