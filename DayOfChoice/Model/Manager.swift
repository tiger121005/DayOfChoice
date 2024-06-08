//
//  Manager.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/15.
//

import Foundation

class Manager {
    static var shared = Manager()
    
    private init() {}
    
    var user: User = User(name: "no name", minor: 0)
//    var logs: [Logs] = []
    var first: Bool = true
}
