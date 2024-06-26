//
//  Article.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/15.
//

import Foundation
import FirebaseFirestore
import SwiftUI

public struct User: Codable {
    var name: String
    var minor: Int
    @DocumentID var id: String?
}

public struct Question: Codable {
    let question: String
    let select1: String
    let select2: String
    @DocumentID var id: String?
}

public struct Logs {
    let question: String
    let select1: String
    let select2: String
    var number1: Int
    var number2: Int
    var select: Int
    let id: String
}

public struct Answer: Codable {
    var select: Int
    @DocumentID var id: String?
    
}

public struct Result: Codable {
    let number1: Int
    let number2: Int
}

public struct Friend: Codable {
    let name: String
    var matchNum: Int
    let id: String
}

public struct ChartData {
    let title: String
    let number: Double
    let color: Color
}


enum UserDefaultsKey: String {
    case uid = "uid"
    case name = "name"
    case minor = "0"
    
    func get() -> String? {
        return UserDefaults(suiteName: "group.com.Ito.taiga.DayOfChoice")?.string(forKey: self.rawValue)
    }
    
    func set(value: String) {
        UserDefaults(suiteName: "group.com.Ito.taiga.DayOfChoice")?.set(value, forKey: self.rawValue)
    }
    
    func remove() {
        UserDefaults(suiteName: "group.com.Ito.taiga.DayOfChoice")?.removeObject(forKey: self.rawValue)
    }
}
