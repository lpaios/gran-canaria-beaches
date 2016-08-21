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
        let lastWeekDate = NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: -1, toDate: NSDate(), options: NSCalendarOptions())!
        let styler = NSDateFormatter()
        styler.dateFormat = "yyyyMMdd"
        return styler.stringFromDate(lastWeekDate)
    }
}

