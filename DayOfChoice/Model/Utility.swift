//
//  Utility.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/19.
//

import Foundation

let serialQueue = DispatchQueue(label: "com.example.MyApp.serialQueue")

struct Utility {
    static var shared = Utility()
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    var manager = Manager.shared
    
    func vote(select: Int) async {
        await userFB.addAnswer(select: select)
        await questionFB.addNum(select: select)
    }
    
}
