//
//  Realm.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/22.
//

import Foundation
import RealmSwift

class RealmData: Object {
    @objc dynamic var question: String = ""
    @objc dynamic var select1: String = ""
    @objc dynamic var select2: String = ""
    @objc dynamic var number1: Int = 0
    @objc dynamic var number2: Int = 0
    @objc dynamic var select: Int = 0
    @objc dynamic var id: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class FriendsData: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var matchNum: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
