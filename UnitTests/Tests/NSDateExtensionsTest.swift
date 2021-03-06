import XCTest

@testable import WorkWeek

class NSDateExtensionsTest: XCTestCase {

    func testDateGivesCorrectDayOfWeek() {
        //interval since reference date gives Jan 1, 2001 a Monday
        //this result can be found by running `$ cal Jan 2001` in your shell
        let date = Date(timeIntervalSinceReferenceDate: 0)

        NSTimeZone.default = TimeZone(secondsFromGMT: 0)!
        //set time zone to gmt else the day of the week could be interpreted
        //incorrectly. When testing this I originally had some testing issues.
        // asking for the NSDate(timeIntervalSinceReferenceDate: 0) gives Jan 1, 2001 00:00:00 GMT
        // When printing this out using a formatter as dayOfWeek does, I live in
        // United States Central time, which is some hours less than gmt, thus
        // the day of the week was 1 prior to what I was expecting.
        XCTAssertEqual(date.dayOfWeek, "Mon",
            "Day of week is calculated Correctly. Jan 1, 2001 is a Monday")
    }

    func testDateForReset() {
        NSTimeZone.default = TimeZone(secondsFromGMT: 0)!
        let day = 0//sunday
        let hour = 4 // 4 am
        let minute = 0 //always zero
        let resetDate = getDateForReset(day, hour: hour, minute: minute)
        // reset date should have components of sunday 4: 00 am
        let resetComps = (Calendar.current as NSCalendar).components(
            [NSCalendar.Unit.weekday, NSCalendar.Unit.hour, NSCalendar.Unit.minute],
            from: resetDate)
        XCTAssertEqual(resetComps.weekday, 1, "Reset day set to sunday")
        XCTAssertEqual(resetComps.hour, 4, "Reset hour is 4 am ")
        let comparison = Date().compare(resetDate)
        XCTAssertEqual(comparison, ComparisonResult.orderedAscending,
                       "Reset Date is in the future")
        //but it is less than 1 week in the future

        //one week 7days, 24hours,60minutes, 60 seconds
        let oneWeekComparison = Date(timeIntervalSinceNow: 7 * 24 * 60 * 60)
                                .compare(resetDate)
        XCTAssertEqual(oneWeekComparison, ComparisonResult.orderedDescending,
                       "Reset Date is less than one week in the future")
    }

    func testDateForReset_2() {
        NSTimeZone.default = TimeZone(secondsFromGMT: 0)!

        let day = 2
        let hour = 4 // 4 am
        let minute = 0 //always zero
        let resetDate = getDateForReset(day, hour: hour, minute: minute)
        // reset date should have components of sunday 4: 00 am
        let resetComps = Calendar.current.dateComponents([
            Calendar.Component.weekday, Calendar.Component.hour, Calendar.Component.minute
            ], from: resetDate)
        XCTAssertEqual(resetComps.weekday, day + 1, "Reset day set to currentWeekday")
        XCTAssertEqual(resetComps.hour, 4, "Reset hour is 4 am ")
        
        let comparison = Date().compare(resetDate)
        XCTAssertEqual(comparison, ComparisonResult.orderedAscending,
                       "Reset Date is in the future")
        //but it is less than 1 week in the future
        let oneWeekComparison = Date(timeIntervalSinceNow: 7 * 24 * 60 * 60) //time interva since **now** in a test!!!!!
                                .compare(resetDate) //one week 7days, 24hours,60minutes, 60 seconds
        XCTAssertEqual(oneWeekComparison, ComparisonResult.orderedDescending,
                       "Reset Date is less than one week in the future")
    }

    func testDateForReset_4() {
        NSTimeZone.default = TimeZone(secondsFromGMT: 0)!
        //set reset day to be same day as it is now.

        let day = 4
        let hour = 4 // 4 am
        let minute = 0 //always zero
        let resetDate = getDateForReset(day, hour: hour, minute: minute)
        // reset date should have components of sunday 4: 00 am
        let resetComps = (Calendar.current as NSCalendar).components(
            [NSCalendar.Unit.weekday, NSCalendar.Unit.hour, NSCalendar.Unit.minute],
            from: resetDate)
        XCTAssertEqual(resetComps.weekday, day + 1, "Reset day set to currentWeekday")
        XCTAssertEqual(resetComps.hour, 4, "Reset hour is 4 am ")
        let comparison = Date().compare(resetDate)
        XCTAssertEqual(comparison, ComparisonResult.orderedAscending,
                       "Reset Date is in the future")
        //but it is less than 1 week in the future
        let oneWeekComparison = Date(timeIntervalSinceNow: 7 * 24 * 60 * 60)
                                .compare(resetDate) //one week 7days, 24hours,60minutes, 60 seconds
        XCTAssertEqual(oneWeekComparison, ComparisonResult.orderedDescending,
                       "Reset Date is less than one week in the future")
    }

    func testDateForReset_6() {
        NSTimeZone.default = TimeZone(secondsFromGMT: 0)!
        //set reset day to be same day as it is now.

        let day = 6
        let hour = 4 // 4 am
        let minute = 0 //always zero
        let resetDate = getDateForReset(day, hour: hour, minute: minute)
        // reset date should have components of sunday 4: 00 am
        let resetComps = (Calendar.current as NSCalendar).components(
            [NSCalendar.Unit.weekday, NSCalendar.Unit.hour, NSCalendar.Unit.minute],
            from: resetDate)
        XCTAssertEqual(resetComps.weekday, day + 1, "Reset day set to currentWeekday")
        XCTAssertEqual(resetComps.hour, 4, "Reset hour is 4 am ")
        let comparison = Date().compare(resetDate)
        XCTAssertEqual(comparison, ComparisonResult.orderedAscending,
                       "Reset Date is in the future")
        //but it is less than 1 week in the future
        let oneWeekComparison = Date(timeIntervalSinceNow: 7 * 24 * 60 * 60)
                                .compare(resetDate) //one week 7days, 24hours,60minutes, 60 seconds
        XCTAssertEqual(oneWeekComparison, ComparisonResult.orderedDescending,
                       "Reset Date is less than one week in the future")
    }

    func testHourMinuteCalculations() {

        let referenceDate = Date(timeIntervalSinceReferenceDate: 0)
        let twoHours = Date(timeIntervalSinceReferenceDate: 60*60*2)
        let timeDiff = hoursMinutesFromDate(date: referenceDate, toDate: twoHours)
        XCTAssert(timeDiff.hours == 2, "Time difference of 2 hours is calculated correctly")
        XCTAssert(timeDiff.minutes == 0, "Time difference of 2 hours is calculated correctly")

        let twoAndAHalf = Date(timeIntervalSinceReferenceDate: 60*60*2 + 60*30)
        let timeDiff2 = hoursMinutesFromDate(date: referenceDate, toDate: twoAndAHalf)
        XCTAssert(timeDiff2.hours == 2, "Time diff of 2hour 30 minutes is calculated")
        XCTAssert(timeDiff2.minutes == 30, "Time diff of 2hour 30 minutes is calculated")
    }
}
