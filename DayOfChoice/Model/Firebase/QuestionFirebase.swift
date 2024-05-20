//
//  Question.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/15.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class QuestionFirebase: ObservableObject {
    
    static let shared = QuestionFirebase()
    
    let db = Firestore.firestore()
    let questionRef: CollectionReference!
    
    init() {
        self.questionRef = db.collection("question")
    }
    
    func addNum(questionID: String, select: Int) {
        if select == 1 {
            questionRef.document(questionID).updateData([
                "number1": FieldValue.increment(Int64(1))
            ]) { err in
                if let err {
                    print("Error addNum")
                } else {
                    print("Success addNum")
                }
            }
        } else {
            questionRef.document(questionID).updateData([
                "number2": FieldValue.increment(Int64(1))
            ]) { err in
                if let err {
                    print("Error addNum")
                } else {
                    print("Success addNum")
                }
                
            }
        }
    }
    
    func getQuestion() async -> Question? {
        await withCheckedContinuation { continuation in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMdd"
            questionRef.document(dateFormatter.string(from: Date())).getDocument { (document, err) in
                guard let document, document.exists else {
                    continuation.resume(returning: nil)
                    return
                }
                do {
                    let question = try document.data(as: Question.self)
                    continuation.resume(returning: question)
                } catch {
                    print("Error get question")
                    continuation.resume(returning: nil)
                }
                
            }
        }
    }
    
    func getPrequestion() async -> Question? {
        await withCheckedContinuation { continuation in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMdd"
            guard let date = UserDefaultsKey.preDay.get() else {
                continuation.resume(returning: nil)
                return
            }
            
            questionRef.document("0519").getDocument { (document, err) in
                guard let document, document.exists else {
                    continuation.resume(returning: nil)
                    return
                }
                do {
                    let question = try document.data(as: Question.self)
                    continuation.resume(returning: question)
                } catch {
                    print("Error get question")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    
    
    
}
