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
    
    
    func updateTime() -> [Int] {
        
        let baseHour = 8
        let material = Material.shared
        let hour = baseHour + material.randomHours[dayOfYear() - 1]
        let minute = material.randomMinute[dayOfYear() - 1]
        
        return [hour, minute]
    }
    
    func dayOfYear() -> Int {
        let currentDate = Date()
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .year, for: currentDate) ?? 0
    }
    
}
