//
//  QuestionViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/19.
//

import UIKit
import FirebaseAuth
import RealmSwift

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: NaturalLabel!
    @IBOutlet var select1Btn: UIButton!
    @IBOutlet var select2Btn: UIButton!
    @IBOutlet var voteBtn: UIButton!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    let friendFB = FriendFirebase.shared
    let utility = Utility.shared
    let debug = DebugManager()
    let manager = Manager.shared
    
    var selectNum = 0
    var question: Question?
    
    
    
    @IBAction func select1() {
        selectNum = 1
        voteBtn.isEnabled = true
        voteBtn.layer.shadowColor = UIColor.black.cgColor
        
        select1Btn.layer.shadowColor = UIColor.red.cgColor
        select1Btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        select1Btn.layer.shadowRadius = CGFloat(15)
        select1Btn.layer.shadowOpacity = 1
        
        select2Btn.layer.shadowColor = UIColor.black.cgColor
        select2Btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        select2Btn.layer.shadowRadius = CGFloat(5)
        select1Btn.layer.shadowOpacity = 0.4
        
    }
    
    @IBAction func select2() {
        selectNum = 2
        voteBtn.isEnabled = true
        voteBtn.layer.shadowColor = UIColor.black.cgColor
        
        select1Btn.layer.shadowColor = UIColor.black.cgColor
        select1Btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        select1Btn.layer.shadowRadius = CGFloat(5)
        select1Btn.layer.shadowOpacity = 0.4
        
        select2Btn.layer.shadowColor = UIColor.blue.cgColor
        select2Btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        select2Btn.layer.shadowRadius = CGFloat(15)
        select2Btn.layer.shadowOpacity = 0.4
        
        
    }
    
    @IBAction func vote() {
        Task {
            //今回の投票分
            await userFB.addAnswer(select: selectNum)
            await questionFB.addNum(select: selectNum)
            
            //前回の投票分
            guard let preQuestionID = await self.getPreQuestion() else {
                print("Cannot get pre question")
                self.performSegue(withIdentifier: "toResult", sender: nil)
                return
            }
            let friendIDs = getFriends()
            
            for id in friendIDs {
                await friendFB.judgeMatch(uid: id, questionID: preQuestionID)
            }
            
            
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
    }
   

    func getPreQuestion() async -> String? {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let questions = realm.objects(RealmData.self)
        if questions.count < 2 {
            return nil
        }
        
        return questions[1].id
    }
    
    func getFriends() -> [String] {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let friendIDs = realm.objects(FriendsData.self).map{$0.id}
        return Array(friendIDs)
    }
}

extension QuestionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            
            print(UserDefaults(suiteName: "group.com.Ito.taiga.DayOfChoice")?.string(forKey: "uid"))
            checkFirst()
            await setupData()
            setupView()
            
            
//            DebugManager.shared.deleteFriend()
        }
        
    }
    
    func setupView() {
        
        select1Btn.configuration = nil
        select2Btn.configuration = nil
        
        select1Btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        select2Btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        select1Btn.tintColor = .white
        select2Btn.tintColor = .white
        
        select1Btn.layer.cornerCurve = .continuous
        select2Btn.layer.cornerCurve = .continuous
        
        select1Btn.layer.cornerRadius = 30
        select2Btn.layer.cornerRadius = 30
        
        select1Btn.layer.shadowColor = UIColor.black.cgColor
        select2Btn.layer.shadowColor = UIColor.black.cgColor
        
        select1Btn.layer.shadowOpacity = 0.4
        select2Btn.layer.shadowOpacity = 0.4
        
        select1Btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        select2Btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        select1Btn.layer.shadowRadius = CGFloat(5)
        select2Btn.layer.shadowRadius = CGFloat(5)
        
        voteBtn.layer.cornerCurve = .continuous
        voteBtn.layer.cornerRadius = voteBtn.frame.height / 2
        
        voteBtn.layer.shadowColor = UIColor.white.cgColor
        voteBtn.layer.shadowOpacity = 0.4
        voteBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        voteBtn.layer.shadowRadius = CGFloat(5)
    }
    
    func setupData() async {
        Task {
            
            do {
                let authData = try await Auth.auth().signInAnonymously()
                
                let user = authData.user
                let uid = user.uid
                if UserDefaultsKey.uid.get() != uid {
                    await userFB.createUser(id: uid)
                    UserDefaultsKey.uid.set(value: uid)
                    if UserDefaultsKey.name.get() == nil {
                        UserDefaultsKey.name.set(value: "no name")
                    }
                }
                
            } catch {
                print("login error")
            }
            print("uid", UserDefaultsKey.uid.get())
            
            
            voteBtn.isEnabled = false
            question = await questionFB.getQuestion()
            guard let question else {
                select1Btn.isEnabled = false
                select2Btn.isEnabled = false
                questionLabel.text = "読み込み失敗"
                return
            }
            
            
            self.questionLabel.text = question.question
            self.questionLabel.naturalize()
            self.select1Btn.setTitle(question.select1, for: .normal)
            self.select2Btn.setTitle(question.select2, for: .normal)
            
        }
    }
    
    func checkFirst() {
        
        var realm: Realm {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let id = formatter.string(from: Date())
        if let data = realm.object(ofType: RealmData.self, forPrimaryKey: id) {
            if data.select != 0 {
                manager.first = false
                performSegue(withIdentifier: "toResult", sender: nil)
            }
        }
    }
}
