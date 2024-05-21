//
//  QuestionViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/19.
//

import UIKit
import FirebaseAuth

class QuestionViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var select1Btn: UIButton!
    @IBOutlet var select2Btn: UIButton!
    @IBOutlet var voteBtn: UIButton!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    let utility = Utility.shared
    
    var selectNum = 0
    var question: Question?
    var questionID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            print("uid", UserDefaultsKey.uid.get())
            
            voteBtn.isEnabled = false
            question = await questionFB.getQuestion()
            guard let question else {
                select1Btn.isEnabled = false
                select2Btn.isEnabled = false
                return
            }
            questionLabel.text = question.question
            select1Btn.titleLabel?.text = question.select1
            select2Btn.titleLabel?.text = question.select2
            select1Btn.isEnabled = true
            select2Btn.isEnabled = true
        }
    }
    
    @IBAction func select1() {
        selectNum = 1
        voteBtn.isEnabled = true
    }
    
    @IBAction func select2() {
        selectNum = 2
        voteBtn.isEnabled = true
    }
    
    @IBAction func vote() {
        utility.vote(questionID: questionID, select: selectNum)
        
    }
   

}
