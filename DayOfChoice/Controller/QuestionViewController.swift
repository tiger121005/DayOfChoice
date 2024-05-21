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
    
    var selectNum = 0
    var question: Question?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        Task {
            print("uid", UserDefaultsKey.uid.get())
            
            voteBtn.isEnabled = false
            question = await questionFB.getQuestion()
            guard let question else {
                select1Btn.isEnabled = false
                select2Btn.isEnabled = false
                return
            }
            
            DispatchQueue.main.async {
                self.questionLabel.text = question.question
                self.questionLabel.naturalize()
                self.select1Btn.titleLabel?.text = question.select1
                self.select2Btn.titleLabel?.text = question.select2
            }
            
            self.select1Btn.isEnabled = true
            self.select2Btn.isEnabled = true
        }
    }
    
    func setupView() {
        select1Btn.titleLabel?.textAlignment = NSTextAlignment.center
        select2Btn.titleLabel?.textAlignment = NSTextAlignment.center
        
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
        select1Btn.layer.shadowColor = UIColor.white.cgColor
        select2Btn.layer.shadowColor = UIColor.black.cgColor
        voteBtn.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBAction func select2() {
        selectNum = 2
        voteBtn.isEnabled = true
        select1Btn.layer.shadowColor = UIColor.black.cgColor
        select2Btn.layer.shadowColor = UIColor.white.cgColor
        voteBtn.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBAction func vote() {
        Task {
            await utility.vote(select: selectNum)
        }
    }
   

}
