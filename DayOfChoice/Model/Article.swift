//
//  Article.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/15.
//

import Foundation
import FirebaseFirestore

public struct User: Codable {
    var name: String
    var friends: [Friends]
    var questions: [Question]
    var minor: Int
    @DocumentID var id: String?
}

public struct Question: Codable {
    let question: String
    let select1: String
    let select2: String
    @DocumentID var id: String?
}

public struct Answer: Codable {
    var select: Int
    @DocumentID var id: String?
    
}

public struct Result: Codable {
    let number1: Int
    let number2: Int
}

public struct Friends: Codable {
    let name: String
    var matchNum: Int
    let id: String
}


enum UserDefaultsKey: String {
    case uid = "uid"
    
    func get() -> String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }

    func set(value: String) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }

    func remove() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}
