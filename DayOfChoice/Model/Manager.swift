//
//  Manager.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/15.
//

import Foundation

struct Manager {
    static var shared = Manager()
    
    var user: User = User(name: "no name", friends: [], questions: [], minor: 0)
    var answers: [Answer] = []
}
