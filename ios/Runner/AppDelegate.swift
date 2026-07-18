import Flutter
import UIKit
import UserNotifications
import alarm
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

       try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])

      // Mandatory per the alarm package's INSTALL-IOS.md.
      // Must run inside application(_:didFinishLaunchingWithOptions:) so iOS
      // has a registered handler for the BGTaskScheduler identifier
      // "com.gdelataillade.fetch" before any submitTaskRequest call. Without
      // this, calling Alarm.set() (or Alarm.init() while persisted alarms
      // exist) crashes with EXC_CRASH / SIGABRT and
      // _handleSubmissionWithoutRegistrationForTaskRequest — which is what
      // killed Nikita's app every time the rest-timer was used.
      SwiftAlarmPlugin.registerBackgroundTasks()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
