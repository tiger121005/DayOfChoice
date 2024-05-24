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
import RealmSwift

class QuestionFirebase: ObservableObject {
    
    static let shared = QuestionFirebase()
    
    let db = Firestore.firestore()
    let manager = Manager.shared
    let userFB = UserFirebase.shared
    
    
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
            dateFormatter.dateFormat = "yyyyMMdd"
            db.collection("question").document(String(dateFormatter.string(from: Date()).suffix(4))).getDocument { (document, err) in
                guard let document, document.exists else {
                    continuation.resume(returning: nil)
                    return
                }
                do {
                    let question = try document.data(as: Question.self)
                    
                    let newQuestion = RealmData()
                    newQuestion.question = question.question
                    newQuestion.select1 = question.select1
                    newQuestion.select2 = question.select2
                    newQuestion.id = dateFormatter.string(from: Date())
                    
                    let realm = try! Realm()
                    if realm.object(ofType: RealmData.self, forPrimaryKey: dateFormatter.string(from: Date())) == nil {
                        try! realm.write {
                            realm.add(newQuestion)
                        }
                    }
                    
                    continuation.resume(returning: question)
                    
                } catch {
                    print("Error get question")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
//    func getPrequestion() async -> Question? {
//        await withCheckedContinuation { continuation in
//            if manager.answers.count < 2 {
//                print("There is no data")
//                return
//            }
//            let latest = manager.answers[1]
//            let date = String(latest.id!.suffix(4))
//            
//            db.collection("question").document(date).getDocument { (document, err) in
//                guard let document, document.exists else {
//                    continuation.resume(returning: nil)
//                    return
//                }
//                do {
//                    let question = try document.data(as: Question.self)
//                    continuation.resume(returning: question)
//                } catch {
//                    print("Error get question")
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }
    
    func getPreResult() async {
        let realm = try! await Realm()
        
        
        await MainActor.run {
            manager.logs = realm.objects(RealmData.self).map{Logs(question: $0.question, select1: $0.select1, select2: $0.select2, number1: $0.number1, number2: $0.number2, select: $0.select, id: $0.id)}.sorted(by: {Int($0.id)! > Int($1.id)!})
            if manager.logs.count < 2 {
                print("Error get pre result")
                return
            }
        }
        let latest = manager.logs[1]
        let year = String(latest.id.prefix(4))
        let date = String(latest.id.suffix(4))
        
        do {
            
            let result = try await db.collection("question").document(date).collection("results").document(year).getDocument(as: Result.self)
            
            await MainActor.run {
                if let questionUpdate = realm.object(ofType: RealmData.self, forPrimaryKey: latest.id) {
                    print(4, Thread.current)
                    try! realm.write {
                        questionUpdate.number1 = result.number1
                        questionUpdate.number2 = result.number2
                    }
                    
                    manager.logs[1].number1 = result.number1
                    manager.logs[1].number2 = result.number2
                }
            }
            if result.number1 > result.number2 && manager.logs[1].select == 2 {
                await userFB.addMinor()
            } else if result.number1 < result.number2 && manager.logs[1].select == 1 {
                await userFB.addMinor()
            }
            
        } catch {
            print("Error get pre result")
        }
    }
    
//    func getResult(id: String) async -> Result? {
//        await withCheckedContinuation {continuation in
//            db.collection("question").document(String(id.suffix(4))).collection("results").document(String(id.prefix(4))).getDocument { (document, err) in
//                guard let document, document.exists else {
//                    print("Error get result")
//                    continuation.resume(returning: nil)
//                    return
//                }
//                do {
//                    let result = try document.data(as: Result.self)
//                    continuation.resume(returning: result)
//                } catch {
//                    print("Error get result")
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//        
//    }
}
