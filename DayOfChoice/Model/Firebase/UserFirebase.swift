//
//  User.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/15.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import RealmSwift

class UserFirebase: ObservableObject {
    
    static let shared = UserFirebase()
    
    let db = Firestore.firestore()
    
    
    var manager = Manager.shared
    
    func createUser(id: String) async {
        
        do {
            try db.collection("user").document(id).setData(from: User(name: "no name", minor: 0))
        } catch {
            print("Error create user")
        }
        
    }
    
    func changeName(name: String) async {
        guard let id = UserDefaultsKey.uid.get() else {
            print("Error get user id")
            return
        }
        do {
            try await db.collection("user").document(id).updateData([
                "name": name
            ])
        } catch {
            print("Error change name")
        }
    }
    
    
    func addAnswer(select: Int) async {
        Task {
            guard let uid = UserDefaultsKey.uid.get() else {
                print("Cannnot get uid")
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let id = dateFormatter.string(from: Date())
            do {
                try db.collection("user").document(uid).collection("answers").document(id).setData(from: Answer(select: select))
                
                let newAnswer = RealmData()
                var realm: Realm {
                    var config = Realm.Configuration()
                    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
                    config.fileURL = url?.appendingPathComponent("db.realm")
                    let realm = try! Realm(configuration: config)
                    return realm
                }
                if let updatedata = realm.object(ofType: RealmData.self, forPrimaryKey: id) {
                    try! realm.write {
                        updatedata.select = select
                    }
                }
            } catch {
                print("Error add answer")
            }
        }
    }
    
    
    func addMinor() async {
        guard let uid  = UserDefaultsKey.uid.get() else {
            print("Error get uid")
            return
        }
        do {
            try await db.collection("user").document(uid).updateData([
                "minor": FieldValue.increment(Int64(1))
            ])
            
            guard let current = UserDefaultsKey.minor.get() else {
                print("Error get minor")
                return
            }
            
            guard let int = Int(current) else {
                print("Cannot to int")
                return
            }
            
            UserDefaultsKey.minor.set(value: String(int + 1))
            
            
            
        } catch {
            print("Error add minor")
        }
    }
    
    
    func getAnswers(id: String) async -> [Answer] {
        do {
            let snapshot = try await db.collection("user").document(id).collection("answers").getDocuments()
            var answers: [Answer] = []
            for document in snapshot.documents {
                answers.append(try document.data(as: Answer.self))
            }
            
            answers.sort{ Int($0.id!)! > Int($1.id!)! }
            
            return answers
        } catch {
            print("Error get answers")
            return []
        }
    }
    
}
