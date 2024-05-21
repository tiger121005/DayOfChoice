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
    let manager = Manager.shared
    
    
    
    func addNum(select: Int) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let year = String(formatter.string(from: Date()).prefix(4))
        let date = String(formatter.string(from: Date()).suffix(4))
        if select == 1 {
            do {
                try await db.collection("question").document(date).collection("results").document(year).updateData([
                    "number1": FieldValue.increment(Int64(1))
                ])
            } catch {
                print("Error add num")
            }
        } else {
            do {
                try await db.collection("question").document(date).collection("results").document(year).updateData([
                    "number2": FieldValue.increment(Int64(1))
                ])
            } catch {
                print("Error add num")
            }
        }
    }
    
    func getQuestion() async -> Question? {
        await withCheckedContinuation { continuation in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMdd"
            db.collection("question").document(dateFormatter.string(from: Date())).getDocument { (document, err) in
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
            print("manager3", ObjectIdentifier(manager))
            print("start get pre question")
            guard let latest = manager.answers.first else {
                print("There is no data")
                return
            }
            let date = String(latest.id!.suffix(4))
            
            db.collection("question").document(date).getDocument { (document, err) in
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
    
    func getPreResult() async -> Result? {
        await withCheckedContinuation { continuation in
            guard let latest = manager.answers.first else {
                return
            }
            let year = String(latest.id!.prefix(4))
            let date = String(latest.id!.suffix(4))
            
            db.collection("question").document(date).collection("resuts").document(year).getDocument { (document, err) in
                guard let document, document.exists else {
                    print("Error get pre result")
                    continuation.resume(returning: nil)
                    return
                }
                do {
                    let result = try document.data(as: Result.self)
                    continuation.resume(returning: result)
                } catch {
                    print("Error get pre result")
                    continuation.resume(returning: nil)
                }
            }
            
        }
    }
}
