//
//  DebugManager.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/23.
//

import Foundation
import RealmSwift
import Firebase
import FirebaseFirestore

struct DebugManager {
    
    static let shared = DebugManager()
    
    let db = Firestore.firestore()
    
    func addData() {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        print(realm.objects(RealmData.self))
        
        let data = RealmData()
        data.question = "旅行に行くなら？"
        data.select1 = "国内"
        data.select2 = "国外"
        data.number1 = 852
        data.number2 = 945
        data.select = 2
        data.id = "20240604"
        try! realm.write {
            realm.add(data)
        }
    }
    
    func updateData(id: String) {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        guard let data = realm.object(ofType: RealmData.self, forPrimaryKey: id) else {
            print("cannot get data")
            return
        }
        
        do {
            try realm.write {
                data.select = 2
            }
        } catch {
            print("cannot update data")
        }
    }
    
    
    func deleteFriend() {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let datas = realm.objects(FriendsData.self)
        
        for data in datas {
            do{
              try realm.write{
                realm.delete(data)
              }
            }catch {
              print("Error \(error)")
            }
        }
    }
    
    
    func getAllAnswers(id: String) async {
        do {
            let snapshot = try await db.collection("user").document(id).collection("answers").getDocuments()
            
            
            for document in snapshot.documents {
                let answer = try document.data(as: Answer.self)
                
                let questionID = String(answer.id!.suffix(4))
                let question = try await db.collection("question").document(questionID).getDocument(as: Question.self)
                
                let realm: Realm = {
                    var config = Realm.Configuration()
                    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
                    config.fileURL = url?.appendingPathComponent("db.realm")
                    let realm = try! Realm(configuration: config)
                    return realm
                }()
                
                let realmData = RealmData()
                realmData.question = question.question
                realmData.select1 = question.select1
                realmData.select2 = question.select2
                realmData.select = answer.select
                realmData.id = answer.id!
                
                if realm.object(ofType: RealmData.self, forPrimaryKey: realmData.id) != nil {
                    continue
                }
                
                try realm.write {
                    realm.add(realmData)
                }
            }
        } catch {
            print("Error get all answers")
        }
    }
    
}

