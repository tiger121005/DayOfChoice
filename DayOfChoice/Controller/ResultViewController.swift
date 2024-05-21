//
//  ResultViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/19.
//

import UIKit
import SwiftUI

class ResultViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var graphView: UIView!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    let material = Material.shared
    let manager = Manager.shared
    let screenWidth = UIScreen.main.bounds.width
    
    var question: Question!
    var result: Result!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await setupData()
            setupGraph()
        }
    }
    
    func setupData() async {
        
        await userFB.getAnswer()
        print("manager2", ObjectIdentifier(manager))
        question = await questionFB.getPrequestion()
        guard let question else {
            print("Cannnot read question")
            return
        }
        questionLabel.text = question.question
        
        result = await questionFB.getPreResult()
    }
    

    func setupGraph() {
        guard let result else {
            print("Cannot read result")
            return
        }
        
        let graphHeight = graphView.frame.height
        
        let bar1 = UIView()
        let bar2 = UIView()
        
        let number1 = Double(result.number1)
        let number2 = Double(result.number2)
        
        let barWidth = CGFloat(50)
        let barX = screenWidth * (3/10)
        let maxHeight = graphHeight -  90
        let topPadding = CGFloat(60)
        
        if result.number1 > result.number2 {
            bar1.frame = CGRect(x: barX,
                                y: topPadding,
                                width: barWidth,
                                height: maxHeight)
            print("bar1", barX, topPadding, barWidth, maxHeight)
            bar2.frame = CGRect(x: screenWidth - barX - barWidth,
                                y: topPadding + (maxHeight - (maxHeight * CGFloat(number2 / number1))),
                                width: barWidth,
                                height: maxHeight * CGFloat(number2 / number1))
            
            print("bar2", screenWidth - barX - barWidth,
                  topPadding + (maxHeight - (maxHeight * CGFloat(number2 / number1))),
                  barWidth,
                  maxHeight * CGFloat(number2 / number1))
        } else {
            bar1.frame = CGRect(x: barX,
                                y: topPadding + (maxHeight - (maxHeight * CGFloat(number1 / number2))),
                                width: barWidth,
                                height: maxHeight * CGFloat((number1 / number2)))
            print("bar1", barX,
                  topPadding + (maxHeight - (maxHeight * CGFloat(number2 / number1))),
                  barWidth,
                  maxHeight * CGFloat(number1 / number2))
            
            bar2.frame = CGRect(x: screenWidth - barX - barWidth,
                                y: topPadding,
                                width: barWidth,
                                height: maxHeight)
            print("bar2", screenWidth - barX - barWidth, topPadding, barWidth, maxHeight)
        }
        
        let bar1Layer = CAGradientLayer()
        bar1Layer.frame = CGRect(x: 0, y: 0, width: barWidth, height: bar1.frame.height)
        bar1Layer.colors = material.redGradient
        bar1.layer.insertSublayer(bar1Layer, at:0)
        
        let bar2Layer = CAGradientLayer()
        bar2Layer.frame = CGRect(x: 0, y: 0, width: barWidth, height: bar2.frame.height)
        bar2Layer.colors = material.blueGradient
        bar2.layer.insertSublayer(bar2Layer, at: 0)
        
        
        graphView.addSubview(bar1)
        graphView.addSubview(bar2)
        
        
        let select1Labal = UILabel()
        let select2Label = UILabel()
        
        let labelHeight = CGFloat(20)
        let labelWidth = CGFloat(100)
        let labelY = topPadding + maxHeight + 10
        
        select1Labal.text = question.select1
        select2Label.text = question.select2
        
        select1Labal.font = .systemFont(ofSize: 20)
        select2Label.font = .systemFont(ofSize: 20)
        
        select1Labal.textColor = .black
        select2Label.textColor = .black
        
        select1Labal.textAlignment = NSTextAlignment.center
        select2Label.textAlignment = NSTextAlignment.center
        
        select1Labal.frame = CGRect(x: bar1.frame.minX - 25, y: labelY, width: labelWidth, height: labelHeight)
        select2Label.frame = CGRect(x: bar2.frame.minX - 25, y: labelY, width: labelWidth, height: labelHeight)
        
        graphView.addSubview(select1Labal)
        graphView.addSubview(select2Label)
        
        
        let rate1Label = UILabel()
        let rate2Label = UILabel()
        
        let rateHeight = CGFloat(25)
        let rateWidth = CGFloat(100)
        
        let rate1 = round(number1 / (number1 + number2) * 1000) / 10
        
        
        rate1Label.text = "\(rate1) %"
        rate2Label.text = "\(100 - rate1) %"
        
        rate1Label.font = .systemFont(ofSize: 25)
        rate2Label.font = .systemFont(ofSize: 25)
        
        rate1Label.textColor = .black
        rate2Label.textColor = .black
        
        rate1Label.textAlignment = NSTextAlignment.center
        rate2Label.textAlignment = NSTextAlignment.center
        
        rate1Label.frame = CGRect(x: bar1.frame.minX - 25, y: bar1.frame.minY - 35, width: rateWidth, height: rateHeight)
        rate2Label.frame = CGRect(x: bar2.frame.minX - 25, y: bar2.frame.minY - 35, width: rateWidth, height: rateHeight)
        
        graphView.addSubview(rate1Label)
        graphView.addSubview(rate2Label)
        
        let baseLine = UIView()
        baseLine.backgroundColor = .black
        baseLine.frame = CGRect(x: 20, y: bar1.frame.maxY, width: screenWidth - 40, height: 2)
        
        graphView.addSubview(baseLine)
        
        
        let starView = UIImageView()
        
        starView.image = UIImage(systemName: "star.fill")
        let starWidth = CGFloat(50)
        
        if manager.answers[1].select == 1 {
            starView.tintColor = .red
            starView.frame = CGRect(x: bar1.frame.minX, y: rate1Label.frame.minY - 55, width: starWidth, height: starWidth)
        } else {
            starView.tintColor = .blue
            starView.frame = CGRect(x: bar2.frame.minX, y: rate2Label.frame.minY - 55, width: starWidth, height: starWidth)
        }
        
        graphView.addSubview(starView)
    }
   

}
