import UIKit

class DayTimePicker: NSObject {
}

extension DayTimePicker: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2 //Weekday, Hour
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return NSCalendar.currentCalendar().maximumRangeOfUnit(.CalendarUnitWeekday).length
        case 1: return NSCalendar.currentCalendar().maximumRangeOfUnit(.CalendarUnitHour).length
        default:
            println("Something is wrong")
            return 0
        }
    }
}

extension DayTimePicker: UIPickerViewDelegate {

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {

        switch component{
        case 0: return makeADayView(row, withLabel: UILabel(frame: CGRectZero))
        case 1: return makeAnHourView(row, withLabel: UILabel(frame: CGRectZero))
        default:
            println("Something is wrong! asked for picker views for component: \(component)")
            return view //return the same view?
        }
    }

    func makeADayView(row: Int, withLabel label: UILabel) -> UIView {
        let dateFormatter = NSDateFormatter()
        let days = dateFormatter.standaloneWeekdaySymbols as! [String]
        label.text = days[row]
        return label
    }

    func makeAnHourView(row: Int, withLabel label: UILabel) -> UIView {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let cal = NSCalendar.currentCalendar()
        let comp = NSDateComponents()
        comp.hour = row
        label.text = dateFormatter.stringFromDate(cal.dateFromComponents(comp)!)
        return label
    }

}