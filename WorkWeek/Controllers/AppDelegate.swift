import UIKit
import Prelude

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var workManager = WorkManager()
    lazy var locationManager: LocationManager =
                             LocationManager(locationDelegate: self.workManager)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ADHelper.registerDefaults()
        handleLaunchOptions(launchOptions, workManager: workManager)
        loadInterface()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        workManager.resetDataIfNeeded() //move these to the correct areas
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func application(_ application: UIApplication,
                     didReceive notification: UILocalNotification) {
        guard let vc = window?.rootViewController else { return }
        ADHelper.showGoHomeAlertSheet(onViewController: vc)
    }

    func loadInterface() {
        window?.rootViewController = ADHelper.loadInterface()
    }

    func handleLaunchOptions(_ options: [AnyHashable: Any]?, workManager: WorkManager) {
        if let _ = options?[UIApplicationLaunchOptionsKey.location] as? NSNumber {
            workManager.resetDataIfNeeded()
            locationManager.startUpdatingLocation()
        }
    }
}

class ADHelper {

    static func loadInterface(_ defaults: UserDefaults = Defaults.standard) -> UIViewController? {
        let onboardingHasCompleted = defaults.bool(forKey: SettingsKey.OnboardingComplete.rawValue)
        return getCorrectStoryboard( onboardingHasCompleted )
    }

    static func getCorrectStoryboard(_ onboardingComplete: Bool ) -> UIViewController? {
        let storyboard = UIStoryboard.load(onboardingComplete ? .Main : .Onboarding)
        return storyboard.instantiateInitialViewController()
    }

    static func showGoHomeAlertSheet(onViewController vc: UIViewController) {

        let alert = UIAlertController(title: "WorkWeek",
                                      message: "Go Home!",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction = UIAlertAction(title: "OK",
                                          style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(defaultAction)
        vc.present(alert, animated: true, completion: nil)
    }

    static func registerDefaults(_ userDefaults: UserDefaults = Defaults.standard) {
        let defaultResetDate = getDateForReset(0, hour: 4, minute: 0)
        print("Registering Reset Date: \(defaultResetDate)")
        let defaults: [SettingsKey: Any] = [
            SettingsKey.OnboardingComplete: false, //default settings screen is not shown
            SettingsKey.HoursInWorkWeek: 40,    // 40 hour work week
            SettingsKey.ResetDay: 0,             // Sunday
            SettingsKey.ResetHour: 4,            // 4 am
            SettingsKey.WorkRadius: 200,         // 200m work radius
            SettingsKey.ClearDate: defaultResetDate
        ]
        defaults |> userDefaults.registerDefaults
    }

}
