import Foundation
import XCTest

import WorkWeek

class NSDateExtensionsTest: XCTestCase {

    func testDateGivesCorrectDayOfWeek(){
        //interval since reference date gives Jan 1, 2001 a Monday 
        //this result can be found by running `$ cal Jan 2001` in your shell
        let date = NSDate(timeIntervalSinceReferenceDate: 0)

        NSTimeZone.setDefaultTimeZone(NSTimeZone(forSecondsFromGMT: 0))
        //set time zone to gmt else the day of the week could be interpreted
        //incorrectly. When testing this I originally had some testing issues.
        // asking for the NSDate(timeIntervalSinceReferenceDate: 0) gives Jan 1, 2001 00:00:00 GMT
        // When printing this out using a formatter as dayOfWeek does, I live in 
        // United States Central time, which is some hours less than gmt, thus 
        // the day of the week was 1 prior to what I was expecting.
        XCTAssertEqual(date.dayOfWeek, "Mon",
            "Day of week is calculated Correctly. Jan 1, 2001 is a Monday")
    }

    func testDateForReset(){
        NSTimeZone.setDefaultTimeZone(NSTimeZone(forSecondsFromGMT: 0))
        let day = 0//sunday
        let hour = 4 // 4 am
        let minute = 0 //always zero
        let resetDate = getDateForReset(day, hour, minute)
        // reset date should have components of sunday 4: 00 am
        let resetComps = NSCalendar.currentCalendar().components(
            NSCalendarUnit.CalendarUnitWeekday |
            NSCalendarUnit.CalendarUnitHour |
            NSCalendarUnit.CalendarUnitMinute,
            fromDate: resetDate!)
        XCTAssertEqual(resetComps.weekday, 1, "Reset day set to sunday")
        XCTAssertEqual(resetComps.hour, 4, "Reset hour is 4 am ")
        let comparison = NSDate().compare(resetDate!)
        XCTAssertEqual(comparison, NSComparisonResult.OrderedAscending, "Reset Date is in the future")
        //but it is less than 1 week in the future
        let oneWeekComparison = NSDate(timeIntervalSinceNow: 7 * 24 * 60 * 60).compare(resetDate!) //one week 7days, 24hours,60minutes, 60 seconds
        XCTAssertEqual(oneWeekComparison, NSComparisonResult.OrderedDescending, "Reset Date is less than one week in the future")


    }
}
