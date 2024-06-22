//
//  LogViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/21.
//

import UIKit
import SwiftUI
import Charts
import RealmSwift

class LogViewController: UIViewController {
    
    @IBOutlet var logView: UIView!
    @IBOutlet var redBorder: UIView!
    @IBOutlet var blueBorder: UIView!
    @IBOutlet var voteNumLabel: UILabel!
    @IBOutlet var minorRateLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    let manager = Manager.shared
    let questionFB = QuestionFirebase.shared
    let material = Material.shared
    
    var logs: [Logs] = []
    var minor = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await setupCollectionView()
            setupLogView()
            
        }
    }
    
    func setupLogView() {
        
                
        let red = CAGradientLayer()
        red.frame = CGRect(x: 0, y: 0, width: redBorder.frame.width, height: redBorder.frame.height)
        red.colors = material.redGradient
        red.startPoint = CGPoint(x: 0, y: 0.5)
        red.endPoint = CGPoint(x: 1, y: 0.5)
        redBorder.layer.insertSublayer(red, at:0)
        
        let blue = CAGradientLayer()
        blue.frame = CGRect(x: 0, y: 0, width: blueBorder.frame.width, height: blueBorder.frame.height)
        blue.colors = material.blueGradient
        blue.startPoint = CGPoint(x: 1, y: 0.5)
        blue.endPoint = CGPoint(x: 0, y: 0.5)
        blueBorder.layer.insertSublayer(blue, at:0)
        
    }
    
    func setupCollectionView() async {
        collectionView.delegate = self
        collectionView.dataSource = self
        //        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let todayID = formatter.string(from: Date())
        
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        logs = realm.objects(RealmData.self).map{Logs(question: $0.question, select1: $0.select1, select2: $0.select2, number1: $0.number1, number2: $0.number2, select: $0.select, id: $0.id)}.sorted{Int($0.id)! > Int($1.id)!}.filter{$0.select != 0}
        
        
        
        for i in 0..<logs.count {
            
            let log = logs[i]
            if log.id == todayID {
                continue
            }
            
            if log.number1 + log.number2 == 0 {
                await questionFB.getResult(id: log.id, select: log.select)
                guard let data = realm.object(ofType: RealmData.self, forPrimaryKey: log.id) else {
                    print("Cannot get realm data")
                    continue
                }
                logs[i].number1 = data.number1
                logs[i].number2 = data.number2
                
            }
            if log.number1 < log.number2 && log.select == 1 {
                minor += 1
            } else if log.number1 > log.number2 && log.select == 2 {
                minor += 1
            }
            
        }
        minorRateLabel.text = "\(round(Double(minor) / Double(logs.count - 1) * 1000) / 10) ％"
        voteNumLabel.text = "\(logs.count - 1) 回"
        
        for log in logs {
            
        }

        collectionView.reloadData()
    }

}

extension LogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        logs.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath)
        
        
        let log = logs[indexPath.row + 1]
        
        let datas = [ChartData(title: log.select2, number: Double(log.number2), color: .blue),
                     ChartData(title: log.select1, number: Double(log.number1), color: .red)]
        
        
        
        
        cell.contentConfiguration = UIHostingConfiguration {
            ZStack {
                
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30), style: .continuous)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 5, x: 0, y: 3)
                    .frame(height: 278)
                
                
                VStack {
                    Text(insertWordJoiners(string: log.question))
                        .font(.footnote)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    Chart(datas, id: \.title) { data in
                        SectorMark(angle: .value("number", data.number))
                            .foregroundStyle(data.color)
                    }
                    .padding(.horizontal, 40)
                    
                    HStack {
                        VStack {
                            Text("\(rate1(number1: log.number1, number2: log.number2)) %")
                                .foregroundStyle(Color.red)
                                .font(.title3)
                            
                            Text(log.select1)
                                .foregroundStyle(Color.red)
                                .font(.footnote)
                            
                            
                            if log.select == 1 {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.red)
                                    .frame(height: 12)
                                    .padding(.bottom, 15)
                            } else {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width: 12, height: 12)
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        VStack {
                            
                            Text("\(rate2(number1: log.number1, number2: log.number2)) %")
                                .foregroundStyle(Color.blue)
                                .font(.title3)
                            Text(log.select2)
                                .foregroundStyle(Color.blue)
                                .font(.footnote)
                            
                            if log.select == 2 {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.blue)
                                    .frame(height: 12)
                                    .padding(.bottom, 15)
                            } else {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(width: 12, height: 12)
                                    .padding(.bottom, 10)
                            }
                            
                            
                        }
                        .padding(.trailing, 8)
                        
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.43)
        }
        
        
        
        return cell
    }
    
    func rate1(number1: Int, number2: Int) -> String {
        let data1 = Double(number1)
        let data2 = Double(number2)
        let double = round(data1 / (data1 + data2) * 1000) / 10
        return String(String(double).prefix(4))
    }
    
    func rate2(number1: Int, number2: Int) -> String {
        let data1 = Double(number1)
        let data2 = Double(number2)
        let double = round(data1 / (data1 + data2) * 1000) / 10
        return String(String(100 - double).prefix(4))
    }
    
    func insertWordJoiners(string: String) -> String {
        let wordJoiner = "\u{2060}"
        let characters = string.map { String($0) }
        let modifiedString = characters.joined(separator: wordJoiner)
        print(modifiedString)
        return modifiedString
    }
}

extension LogViewController: UICollectionViewDelegate {
    
}


