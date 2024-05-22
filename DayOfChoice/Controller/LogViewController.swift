//
//  LogViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/21.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet var voteNumLabel: UILabel!
    @IBOutlet var minorRateLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    let manager = Manager.shared
    let questionFB = QuestionFirebase.shared
    
    var results: [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        voteNumLabel.text = "\(manager.logs.count) 回"
        minorRateLabel.text = "\(round(Double(manager.user.minor) / Double(manager.logs.count) * 1000) / 10) ％"
        
        setupCollectionView()
        
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        
        Task {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let todayID = formatter.string(from: Date())
            
            for log in self.manager.logs {
                
                if log.id == todayID {
                    continue
                }
                
                guard let result = await self.questionFB.getResult(id: log.id) else {
                    continue
                }
                self.results.append(result)
            }
            
            collectionView.reloadData()
        }
    }

}

extension LogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath)
        
        cell.contentConfiguration = CustomCell(
            title1: manager.logs[indexPath.row + 1].select1,
            number1: manager.logs[indexPath.row + 1].number1,
            title2: manager.logs[indexPath.row + 1].select2,
            number2: manager.logs[indexPath.row + 1].number2) as? any UIContentConfiguration
        
        return cell
    }
    
    
}

extension LogViewController: UICollectionViewDelegate {
    
}


