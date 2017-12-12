
import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    requestNotification()
    
    return true
  }

  private func requestNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, .sound, .badge]) { (grant, error) in
      print("Grant:" , grant)
      print("Error:" ,error)
      
      DispatchQueue.main.async {
         UIApplication.shared.registerForRemoteNotifications()
      }
      
      UNUserNotificationCenter.current().delegate = self
  
//      여러개의 노티피케이션 카테고리로 묶기, 실제 사용하는 앱이 있나??
      let action = UNNotificationAction(
        identifier: "action",
        title: "확인",
        options: .destructive)
      
      let action2 = UNTextInputNotificationAction(
        identifier: "action2",
        title: "text send",
        options: .foreground)
      
      let category = UNNotificationCategory(
        identifier: "category1",
        actions: [action, action2],
        intentIdentifiers: [],
        options: UNNotificationCategoryOptions.customDismissAction)
      
      UNUserNotificationCenter.current().setNotificationCategories([category])
    }
  }
  
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print(deviceToken)
    
    let tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)}
      let token = tokenParts.joined()
    print("devicetoken:", token)
    }

  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//    todo error handling
  }

  }

//foreground 상태일때 불림
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .badge, .sound])
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}

