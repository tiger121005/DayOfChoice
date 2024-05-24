//
//  QuestionViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/19.
//

import UIKit
import FirebaseAuth

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: NaturalLabel!
    @IBOutlet var select1Btn: UIButton!
    @IBOutlet var select2Btn: UIButton!
    @IBOutlet var voteBtn: UIButton!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    let utility = Utility.shared
    let debug = DebugManager()
    
    var selectNum = 0
    var question: Question?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
        
        Task {
            
            do {
                let authData = try await Auth.auth().signInAnonymously()
                
                let user = authData.user
                let uid = user.uid
                if UserDefaultsKey.uid.get() != uid {
                    await userFB.createUser(id: uid)
                    UserDefaultsKey.uid.set(value: uid)
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
                return
            }
            
            self.questionLabel.text = question.question
            self.questionLabel.naturalize()
            self.select1Btn.setTitle(question.select1, for: .normal)
            self.select2Btn.setTitle(question.select2, for: .normal)
            
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
            await userFB.addAnswer(select: selectNum)
            await questionFB.addNum(select: selectNum)
            
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
    }
   

}
