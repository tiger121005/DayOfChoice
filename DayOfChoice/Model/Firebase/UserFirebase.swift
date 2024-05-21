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

class UserFirebase: ObservableObject {
    
    static let shared = UserFirebase()
    
    let db = Firestore.firestore()
    var userRef: DocumentReference!
    var answersRef: CollectionReference!
    
    var manager = Manager.shared
    
    func createUser(id: String) {
        do {
            try db.collection("user").document(id).setData(from: User(name: "no name", friends: [], questions: [], minor: 0))
        } catch {
            print("Error create user")
        }
        
    }
    
    func getUserInfo(completion: @escaping (Any) -> Void) {
        db.collection("user").document(UserDefaultsKey.uid.get() ?? "").getDocument { (document, err) in
            if let err {
                print("Error getting user information: \(err)")
                completion(true)
            } else {
                if let document, document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        completion(true)
                    } catch {
                        print("Error getting user information: \(String(describing: err))")
                        completion(true)
                    }
                } else {
                    print("Error getting user information: \(String(describing: err))")
                    completion(true)
                }
            }
        }
    }
    
    
    func addAnswer(questionID: String, select: Int, completion: @escaping (Any) -> Void) {
        if let uid = UserDefaultsKey.uid.get() {
            print("uid", uid)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let id = dateFormatter.string(from: Date())
            do {
                try db.collection("user").document(uid).collection("answers").document(id).setData(from: Answer(select: select))
            } catch {
                print("Error add answer")
            }
        }
    }
    
    func getAnswer(completion: @escaping (Any) -> Void) {
        if let uid = UserDefaultsKey.uid.get() {
            db.collection("user").document(uid).collection("answers").getDocuments{collection, err in
                if let err {
                    print("Error get answers \(err)")
                    completion(true)
                } else {
                    guard let collection else {
                        print("Error get answers")
                        return
                    }
                    self.manager.answers = []
                    for document in collection.documents {
                        if let answer = try? document.data(as: Answer.self) {
                            self.manager.answers.append(answer)
                        }
                    }
                    self.manager.answers.sort(by: {Int($0.id!)! > Int($1.id!)!})
                }
            }
            
        }
    }
    
    
    
}
