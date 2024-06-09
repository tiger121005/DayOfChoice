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
        voteBtn.backgroundColor = .black
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
        voteBtn.backgroundColor = .black
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
//            guard let preQuestionID = await self.getPreQuestion() else {
//                print("Cannot get pre question")
//                self.performSegue(withIdentifier: "toResult", sender: nil)
//                return
//            }
//            let friendIDs = getFriends()
//            
//            for id in friendIDs {
//                await friendFB.judgeMatch(uid: id, questionID: preQuestionID)
//            }
            
            
            
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
            print(UserDefaultsKey.uid.get())
            checkFirst()
            await setupData()
            setupView()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaultsKey.name.get() == nil {
            
            UserDefaultsKey.name.set(value: "")
            performSegue(withIdentifier: "toTutorial", sender: nil)
            return
        }
        
        setName()
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
                    
                }
                if UserDefaultsKey.minor.get() == nil {
                    UserDefaultsKey.minor.set(value: "0")
                }
                
            } catch {
                print("login error")
            }
            print("uid", UserDefaultsKey.uid.get())
            
            
            voteBtn.isEnabled = false
            voteBtn.backgroundColor = .gray
            question = await questionFB.getTodayQuestion()
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
    
    func setName() {
        if UserDefaultsKey.name.get() != "" {
            return
        }
        
        let alert = UIAlertController.addAlertWithValidation(register: { name in
            Task {
                await self.userFB.changeName(name: name)
                UserDefaultsKey.name.set(value: name)
            }
        })
        present(alert, animated: true)
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


extension UIAlertController {
    static func addAlertWithValidation(
        register: @escaping (_ text: String) -> Void
    ) -> UIAlertController {
        let descriptionString = "ユーザーネームを入力してください"
        let validationString = "入力してください（スペースのみはできません）"
    var alert = UIAlertController()
        var token: NSObjectProtocol?
        
        // UIAlertControllerを作成する
        alert = UIAlertController(title: "ユーザーネーム", message: descriptionString, preferredStyle: .alert)
        
        // 登録時の処理
        let registerAction = UIAlertAction(title: "登録", style: .default, handler: { _ in
            guard let textFields = alert.textFields else { return }
            
            guard let text = textFields[0].text else { return }
            register(text)
            guard let token = token else { return }
            // オブサーバ登録を解除・・・①
            NotificationCenter.default.removeObserver(token)
        })
        
        
        // テキストフィールドを追加
        alert.addTextField { (textField: UITextField!) -> Void in
            // テキスト変更の通知を受け取るためにオブサーバを登録する・・・②
            token = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: nil) { _ in
                let text = textField.text ?? ""
                registerAction.isEnabled = false
                if text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    // 入力されていないときのエラー
                    let messageString = "\(descriptionString)\n\(validationString)"
                    let range: NSRange = NSString(string: messageString).range(of: validationString )
                    let alertText = NSMutableAttributedString(string: messageString)
            // validationStringのみを赤字にする・・・③
                    alertText.addAttributes([
                        .foregroundColor: UIColor.red,
                    ], range: range)
                    alert.setValue(alertText, forKey: "attributedMessage")
                } else {
                    // 入力文字が5文字以内の場合(正常)
                    let alertText = NSMutableAttributedString(string: descriptionString)
                    alert.setValue(alertText, forKey: "attributedMessage")
                    if text.count != 0 {
            // 登録ボタン非活性(未入力時)
                        registerAction.isEnabled = true
                    }
                }
            }
        }
        // 登録ボタン非活性(初期表示)
        registerAction.isEnabled = false
        
        alert.addAction(registerAction)

        return alert
    }
}
