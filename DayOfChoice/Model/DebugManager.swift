//
//  DebugManager.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/23.
//

import Foundation
import RealmSwift

struct DebugManager {
    
    static let shared = DebugManager()
    func addData22() {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let data = RealmData()
        data.question = "麺を食べるなら？"
        data.select1 = "うどん"
        data.select2 = "ラーメン"
        data.number1 = 498
        data.number2 = 523
        data.select = 2
        data.id = "20240522"
        try! realm.write {
            realm.add(data)
        }
    }
    
    
    func deleteFriend() {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let datas = realm.objects(FriendsData.self)
        
        for data in datas {
            do{
              try realm.write{
                realm.delete(data)
              }
            }catch {
              print("Error \(error)")
            }
        }
    }
    
    
}

