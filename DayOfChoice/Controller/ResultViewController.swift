//
//  ResultViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/19.
//

import UIKit
import SwiftUI
import RealmSwift

class ResultViewController: UIViewController {
    
    @IBOutlet var questionLabel: NaturalLabel!
    @IBOutlet var graphView: UIView!
    @IBOutlet var showLogBtn: UIButton!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    let material = Material.shared
    let manager = Manager.shared
    let screenWidth = UIScreen.main.bounds.width
    
    var log: Logs?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await setupData()
            setupGraph()
        }
    }
    
    func setupView() {
        showLogBtn.layer.cornerRadius = showLogBtn.frame.height / 2
        showLogBtn.layer.cornerCurve = .continuous
        
        showLogBtn.layer.borderColor = UIColor.black.cgColor
        showLogBtn.layer.borderWidth = 3
        
        self.navigationItem.backButtonTitle = "前回の結果"
        self.navigationItem.backButtonDisplayMode = .minimal
    }
    
    func setupData() async {
        
        if manager.first {
            await questionFB.getPreResult()
        } else {
            let realm = try! await Realm()
            manager.logs = realm.objects(RealmData.self).map{Logs(question: $0.question, select1: $0.select1, select2: $0.select2, number1: $0.number1, number2: $0.number2, select: $0.select, id: $0.id)}.sorted(by: { Int($0.id)! > Int($1.id)! })
        }
        
        
        
//        let realm = try! await Realm()
        
//        manager.logs = realm.objects(RealmData.self).map{Logs(question: $0.question, select1: $0.select1, select2: $0.select2, number1: $0.number1, number2: $0.number2, select: $0.select, id: $0.id)}.sorted(by: { Int($0.id)! > Int($1.id)! })
        
        dump(manager.logs)
        if manager.logs.count < 2 {
            print("Cannot read question")
            
            return
        }
        log = manager.logs[1]
        
        Task { @MainActor in
            questionLabel.text = manager.logs[1].question
            questionLabel.naturalize()
        }
        
    }
    

    func setupGraph() {
        
        guard let log else {
            return
        }
        
        let graphHeight = graphView.frame.height
        
        let bar1 = UIView()
        let bar2 = UIView()
        
        let number1 = Double(log.number1)
        let number2 = Double(log.number2)
        
        let barWidth = CGFloat(50)
        let barX = screenWidth * (3/10)
        let maxHeight = graphHeight -  90
        let topPadding = CGFloat(60)
        
        if log.number1 >= log.number2 {
            
            if log.number1 != 0 {
                bar1.frame = CGRect(x: barX,
                                    y: topPadding,
                                    width: barWidth,
                                    height: maxHeight)
            } else {
                bar1.frame = CGRect(x: barX, y: topPadding + maxHeight, width: barWidth, height: 0)
            }
            
            
            
            if log.number2 != 0 {
                
                bar2.frame = CGRect(x: screenWidth - barX - barWidth,
                                    y: topPadding + (maxHeight - (maxHeight * CGFloat(number2 / number1))),
                                    width: barWidth,
                                    height: maxHeight * CGFloat(number2 / number1))
            } else {
                bar2.frame = CGRect(x: screenWidth - barX - barWidth,
                                    y: topPadding + maxHeight,
                                    width: barWidth, height: 0)
            }
            
            
            
            
            
        } else {
            
            bar2.frame = CGRect(x: screenWidth - barX - barWidth,
                                y: topPadding,
                                width: barWidth,
                                height: maxHeight)
            
            if log.number1 != 0 {
                bar1.frame = CGRect(x: barX,
                                    y: topPadding + (maxHeight - (maxHeight * CGFloat(number1 / number2))),
                                    width: barWidth,
                                    height: maxHeight * CGFloat((number1 / number2)))
            } else {
                bar1.frame = CGRect(x: barX, y: topPadding + maxHeight, width: barWidth, height: 0)
            }
            
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
        
        select1Labal.text = log.select1
        select2Label.text = log.select2
        
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
        
        
        let baseLine = UIView()
        baseLine.backgroundColor = .black
        baseLine.frame = CGRect(x: 20, y: bar1.frame.maxY, width: screenWidth - 40, height: 2)
        
        graphView.addSubview(baseLine)
        
        
        
        let rate1Label = UILabel()
        let rate2Label = UILabel()
        
        let rateHeight = CGFloat(25)
        let rateWidth = CGFloat(100)
        
        if number1 + number2 == 0 {
            return
        }
        
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
        
        let starView = UIImageView()
        
        starView.image = UIImage(systemName: "star.fill")
        let starWidth = CGFloat(50)
        
        if manager.logs[1].select == 1 {
            starView.tintColor = .red
            starView.frame = CGRect(x: bar1.frame.minX, y: rate1Label.frame.minY - 55, width: starWidth, height: starWidth)
        } else {
            starView.tintColor = .blue
            starView.frame = CGRect(x: bar2.frame.minX, y: rate2Label.frame.minY - 55, width: starWidth, height: starWidth)
        }
        
        graphView.addSubview(starView)

    }
   

}
