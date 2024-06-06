//
//  FriendFirebase.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/02.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import RealmSwift

public class FriendFirebase: ObservableObject {
    
    static let shared = FriendFirebase()
    
    let db = Firestore.firestore()
    
    
    func searchFriend(id: String) async -> Friend? {
        do {
            let user = try await db.collection("user").document(id).getDocument().data(as: User.self)
            
            guard let id = user.id else {
                print("Error get id")
                return nil
            }
            let result = Friend(name: user.name, matchNum: 0, id: id)
                
            return result
            
        } catch {
            print("Error get user")
            return nil
        }
        
    }
    
    func getFriendName(id: String) async -> String? {
        do {
            print("in get friend 1")
            let user = try await db.collection("user").document(id).getDocument().data(as: User.self)
            print("in get friend 2")
            let name = user.name
            print("in get friend 3")
            return "name"
            
        } catch {
            print("Error get friend")
            return nil
        }
    }
    
    
    
    func judgeMatch(uid: String, questionID: String) async {
        do {
            guard let answer = try await db.collection("user").document(uid).collection("answers").document(questionID).getDocument().data() else {
                print("Error get friend data")
                return
            }
            
            var realm: Realm {
                var config = Realm.Configuration()
                let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
                config.fileURL = url?.appendingPathComponent("db.realm")
                let realm = try! Realm(configuration: config)
                return realm
            }
            guard let myAnswer = realm.object(ofType: RealmData.self, forPrimaryKey: questionID) else {
                print("Error get my answer")
                return
            }
            let mySelect = myAnswer.select
            
            if mySelect == Int(answer["select"] as! String)! {
                if let updatedata = realm.object(ofType: FriendsData.self, forPrimaryKey: uid) {
                    try! realm.write {
                        updatedata.matchNum += 1
                    }
                }
            }
        } catch {
            print("Error get judge match")
        }
    }
}
