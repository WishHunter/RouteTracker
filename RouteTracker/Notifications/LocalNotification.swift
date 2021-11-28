//
//  LocalNotification.swift
//  RouteTracker
//
//  Created by Denis Molkov on 28.11.2021.
//

import Foundation
import UserNotifications

class LocalNotification {
  static var count: Int = 0

  static private func makeNotificationContent(title: String, body: String) -> UNNotificationContent {
    // Внешний вид
    let content = UNMutableNotificationContent()

    content.title = title
    content.body = body
    content.badge = NSNumber(value: LocalNotification.count)

    return content
  }

  static private func makeIntervalNotificationTrigger(seconds: Double) -> UNNotificationTrigger {
    return UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
  }

  static func sendNotificationRequest(
    title: String = "You left me",
    body: String = "Come back, I'm cold and lonely",
    secondsToShow: Double = 20) {

      let content = makeNotificationContent(title: title, body: body)
      let trigger = makeIntervalNotificationTrigger(seconds: secondsToShow)

      LocalNotification.count += 1

      let request = UNNotificationRequest(
        identifier: "boring",
        content: content,
        trigger: trigger)

      let center = UNUserNotificationCenter.current()

      center.add(request) { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
}
