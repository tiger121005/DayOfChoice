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
    
    func getTodayQuestion() async -> Question? {
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
                    
                    var realm: Realm {
                        var config = Realm.Configuration()
                        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
                        config.fileURL = url?.appendingPathComponent("db.realm")
                        let realm = try! Realm(configuration: config)
                        return realm
                    }
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
    
    func getQuestion(id: String) async -> Question? {
        do {
            let questionID = String(id.suffix(4))
            let question = try await db.collection("question").document(questionID).getDocument(as: Question.self)
            
            return question
        } catch {
            print("Error get question")
            return nil
        }
    }
    
    
    func getPreResult(id: String, select: Int) async {
        var realm: Realm {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }
        
        
        let year = String(id.prefix(4))
        let date = String(id.suffix(4))
        guard let data = realm.object(ofType: RealmData.self, forPrimaryKey: id) else {
            return
        }
        
        if  data.number1 != 0 && data.number2 != 0 {
            return
        }
        do {
            
            let result = try await db.collection("question").document(date).collection("results").document(year).getDocument(as: Result.self)
            
            await MainActor.run {
                if let questionUpdate = realm.object(ofType: RealmData.self, forPrimaryKey: id) {
                    print(4, Thread.current)
                    try! realm.write {
                        questionUpdate.number1 = result.number1
                        questionUpdate.number2 = result.number2
                    }
                }
            }
            if result.number1 > result.number2 && select == 2 {
                await userFB.addMinor()
            } else if result.number1 < result.number2 && select == 1 {
                await userFB.addMinor()
            }
            
        } catch {
            print("Error get pre result")
        }
    }
    
}
