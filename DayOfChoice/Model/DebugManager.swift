//
//  DebugManager.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/23.
//

import Foundation
import RealmSwift

struct DebugManager {
    func addData22() {
        let realm = try! Realm()
        
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
}

