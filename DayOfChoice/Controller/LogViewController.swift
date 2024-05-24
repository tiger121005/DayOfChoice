//
//  LogViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/21.
//

import UIKit
import SwiftUI
import Charts

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
    
//    var results: [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLogView()
        setupCollectionView()
    }
    
    func setupLogView() {
        logView.layer.cornerCurve = .continuous
        logView.layer.cornerRadius = 20
        logView.layer.shadowColor = UIColor.black.cgColor
        logView.layer.shadowOffset = CGSize(width: 0, height: 5)
        logView.layer.shadowRadius = CGFloat(5)
        logView.layer.shadowOpacity = 0.7
        voteNumLabel.text = "\(manager.logs.count) 回"
        minorRateLabel.text = "\(round(Double(manager.user.minor) / Double(manager.logs.count) * 1000) / 10) ％"
        
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
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
        Task {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let todayID = formatter.string(from: Date())
            
            for log in self.manager.logs {
                
                if log.id == todayID {
                    continue
                }
                
//                guard let result = await self.questionFB.getResult(id: log.id) else {
//                    continue
//                }
//                self.results.append(result)
            }
            
            collectionView.reloadData()
        }
    }

}

extension LogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        manager.logs.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath)
        
        //        cell.contentConfiguration = CustomCell(
        //            title1: manager.logs[indexPath.row + 1].select1,
        //            number1: manager.logs[indexPath.row + 1].number1,
        //            title2: manager.logs[indexPath.row + 1].select2,
        //            number2: manager.logs[indexPath.row + 1].number2,
        //            select: manager.logs[indexPath.row + 1].select) as? any UIContentConfiguration
        let log = manager.logs[indexPath.row + 1]
        
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
                            
                            Text(datas[0].title)
                                .foregroundStyle(Color.red)
                                .font(.body)
                            
                            
                            if log.select == 1 {
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
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        VStack {
                            
                            Text("\(rate2(number1: log.number1, number2: log.number2)) %")
                                .foregroundStyle(Color.blue)
                                .font(.title3)
                            Text(datas[1].title)
                                .foregroundStyle(Color.blue)
                                .font(.body)
                            
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
            .frame(width: UIScreen.main.bounds.width * 0.4)
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


