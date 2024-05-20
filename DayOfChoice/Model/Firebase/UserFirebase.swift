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
    var userID: String!
    
    var manager = Manager.shared
    
    func setupFirebase(id: String) {
        userID = id
        userRef = db.collection("user").document(id)
        answersRef = db.collection("user").document(id).collection("answers")
    }
    
    func createUser() {
        db.collection("user").document(userID).setData([
            "name": "no name",
            "friends": [],
            "answers": [],
            "questions": []
        ], completion: { err in
            if let err {
                print("Error create user")
            } else {
                print("Success create user")
            }
        })
        
    }
    
    func getUserInfo() async -> User? {
        await withCheckedContinuation { continuation in
            userRef.getDocument { (document, err) in
                if let _err = err {
                    print("Error getting user information: \(_err)")
                    continuation.resume(returning: nil)
                } else {
                    if let document, document.exists {
                        do {
                            let user = try document.data(as: User.self)
                            continuation.resume(returning: user)
                        } catch {
                            continuation.resume(returning: nil)
                            print("Error getting user information: \(String(describing: err))")
                        }
                    } else {
                        continuation.resume(returning: nil)
                        print("Error getting user information: \(String(describing: err))")
                    }
                }
            }
        }
    }
    
    func addAnswer(questionID: String, select: Int) {
        
        answersRef.addDocument(data: [
            "questionID": questionID,
            "select": select,
            "date": Timestamp(date: Date())
        ]) { err in
            if let err {
                print("Error add answer")
            } else {
                print("Success add answer")
            }
        }
    }
    
}
