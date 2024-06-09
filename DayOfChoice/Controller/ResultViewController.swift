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
    
    @IBOutlet var rate1Label: UILabel!
    @IBOutlet var rate2Label: UILabel!
    
    @IBOutlet var select1Label: UILabel!
    @IBOutlet var select2Label: UILabel!
    
    @IBOutlet var yourSelect1: UILabel!
    @IBOutlet var yourSelect2: UILabel!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    let material = Material.shared
    let manager = Manager.shared
    let screenWidth = UIScreen.main.bounds.width
    
    let redView = UIView()
    let blueView = UIView()
    
    
    var log: Logs!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "前回の結果"
        self.navigationItem.titleView?.tintColor = .black
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await setupData()
            redView.backgroundColor = .red
            blueView.backgroundColor = .blue
            redView.frame = CGRect(x: 0, y: 0, width: graphView.frame.width, height: 0)
            blueView.frame = CGRect(x: 0, y: graphView.frame.height, width: graphView.frame.width, height: 0)
            graphView.addSubview(redView)
            graphView.addSubview(blueView)
            graphView.sendSubviewToBack(redView)
            graphView.sendSubviewToBack(blueView)
            UIView.animate(withDuration: 0.5, animations: {
                self.redView.frame = CGRect(x: 0, y: 0, width: self.graphView.frame.width, height: self.graphView.frame.height / 2)
                self.blueView.frame = CGRect(x: 0, y: self.graphView.frame.height / 2, width: self.graphView.frame.width, height: self.graphView.frame.height / 2)
            }, completion: {_ in
                Task {
                    sleep(1)
                    self.setupGraph()
                }
            })
            
            
        }
    }
    
    func setupView() {
        yourSelect1.isHidden = true
        yourSelect2.isHidden = true
        
        self.navigationItem.backButtonTitle = "前回の結果"
        self.navigationItem.backButtonDisplayMode = .minimal
    }
    
    func setupData() async {
        
        if manager.first {
            
        } else {
            
            
        }
        
        
        
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let logs = realm.objects(RealmData.self).map{Logs(question: $0.question, select1: $0.select1, select2: $0.select2, number1: $0.number1, number2: $0.number2, select: $0.select, id: $0.id)}.sorted{Int($0.id)! > Int($1.id)!}
        
        if logs.count < 2 {
            print("Cannot read question")
            
            return
        }
        
        log = logs[1]
        
        
        guard let log else {
            print("Error get log")
            return
        }
        
        Task { @MainActor in
            questionLabel.text = log.question
            questionLabel.naturalize()
            select1Label.text = log.select1
            select2Label.text = log.select2
            
            if log.select == 1 {
                yourSelect1.isHidden = false
            } else {
                yourSelect2.isHidden = false
            }
            
            rate1Label.text = ""
            rate2Label.text = ""
        }
        
    }
    
    func redRate(number1: Int, number2: Int) -> CGFloat {
        let redData = CGFloat(number1)
        let blueData = CGFloat(number2)
        
        print("redData", redData)
        print("blueData", blueData)
        let redRate = redData / (redData + blueData)
        
        return redRate
    }
    
    func setupGraph() {
        let width = graphView.frame.width
        let height = graphView.frame.height
        
        guard let log else {
            print("Cannot get log")
            return
        }
        
        let redRate = redRate(number1: log.number1, number2: log.number2)
        
        rate1Label.text = "\(round(redRate * 1000) / 10)%"
        rate2Label.text = "\(100 - (round(redRate * 1000) / 10))%"
        
        let redHeight = height * redRate
        
        
        redView.backgroundColor = .red
        redView.frame = CGRect(x: 0, y: 0, width: width, height: redHeight)
        
        graphView.addSubview(redView)
        graphView.sendSubviewToBack(redView)
        
        
        blueView.backgroundColor = .blue
        blueView.frame = CGRect(x: 0, y: redHeight, width: width, height: height - redHeight)
        
        graphView.addSubview(blueView)
        graphView.sendSubviewToBack(blueView)
        
        
    }

}
