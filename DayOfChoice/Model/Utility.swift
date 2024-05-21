//
//  Utility.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/19.
//

import Foundation

struct Utility {
    static var shared = Utility()
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    var manager = Manager.shared
    
    func setupFirebase() {
        userFB.getUserInfo(){_ in}
        userFB.getAnswer(){_ in}
        
    }
    
    func vote(questionID: String, select: Int) {
        userFB.addAnswer(questionID: questionID, select: select){_ in}
        questionFB.addNum(questionID: questionID, select: select)
    }
}
