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
    
    let questionFB = QuestionFirebase.shared
    let material = Material.shared
    let screenWidth = UIScreen.main.bounds.width
    
    var question: Question!
    var result: Result!

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            question = await questionFB.getPrequestion()
            guard let question else {
                return
            }
            questionLabel.text = question.question
            
            result = await questionFB.getPreResult()
            guard let result else {
                return
            }
            setupGraph()
        }
    }
    

    func setupGraph() {
        guard let question else {
            return
        }
        
        let graphHeight = graphView.frame.height
        
        let bar1 = UIView()
        let bar2 = UIView()
        
        let barWidth = screenWidth / 16
        let barX = screenWidth * (3 / 8)
        let maxHeight = graphHeight -  80
        let topPadding = CGFloat(40)
        
        if result.number1 > result.number2 {
            bar1.frame = CGRect(x: barX,
                                y: topPadding,
                                width: barWidth,
                                height: maxHeight)
            bar2.frame = CGRect(x: screenWidth - barX - barWidth, 
                                y: topPadding + (maxHeight - (maxHeight * CGFloat(result.number2 / result.number1))),
                                width: barWidth,
                                height: maxHeight * CGFloat((result.number2 / result.number1)))
        } else {
            bar1.frame = CGRect(x: barX,
                                y: topPadding + (maxHeight - (maxHeight * CGFloat(result.number2 / result.number1))),
                                width: barWidth,
                                height: maxHeight * CGFloat((result.number2 / result.number1)))
            bar2.frame = CGRect(x: screenWidth - barX - barWidth,
                                y: topPadding,
                                width: barWidth,
                                height: maxHeight)
        }
        
        let bar1Layer = CAGradientLayer()
        bar1Layer.frame = bar1.frame
        bar1Layer.colors = material.redGradient
        bar1.layer.insertSublayer(bar1Layer, at:0)
        
        let bar2Layer = CAGradientLayer()
        bar2Layer.frame = bar2.frame
        bar2Layer.colors = material.blueGradient
        bar2.layer.insertSublayer(bar2Layer, at: 0)
        
        graphView.addSubview(bar1)
        graphView.addSubview(bar2)
        
        
        
    }
   

}
