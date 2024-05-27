//
//  AppDelegate.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/15.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        
        
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        
        // 通知の許可をリクエスト
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.scheduleDailyNotification()
            } else {
                print("通知が許可されませんでした")
            }
        }
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func scheduleDailyNotification() {
        let utility = Utility.shared
        // 通知の内容を設定
        let content = UNMutableNotificationContent()
        content.title = "究極の2択の時間です"
        content.body = "今日の2択に答えて前回の結果を確認しよう！"
        content.sound = UNNotificationSound.default
        
        // トリガーを設定（毎日午前8時に通知）
        var dateComponents = DateComponents()
        let noticeTime = utility.updateTime()
        dateComponents.hour = noticeTime[0]
        dateComponents.minute = noticeTime[1]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 通知リクエストを作成
        let identifier = "DailyReminder"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // 通知をスケジュール
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知のスケジュールに失敗しました: \(error.localizedDescription)")
            } else {
                print("通知がスケジュールされました")
            }
        }
    }
    
    
    
}

