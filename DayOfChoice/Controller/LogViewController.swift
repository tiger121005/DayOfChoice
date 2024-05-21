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

    override func viewDidLoad() {
        super.viewDidLoad()

        voteNumLabel.text = "\(manager.answers.count) 回"
        minorRateLabel.text = "\(round(Double(manager.user.minor) / Double(manager.answers.count) * 1000) / 10) ％"
        
    }
    

    

}
