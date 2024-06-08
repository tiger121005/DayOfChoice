//
//  ThirdTutorialViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/09.
//

import UIKit

class ThirdTutorialViewController: UIViewController {
    
    @IBOutlet var startBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        startBtn.layer.cornerCurve = .continuous
        startBtn.layer.cornerRadius = startBtn.frame.height / 2
        
        startBtn.layer.shadowColor = UIColor.white.cgColor
        startBtn.layer.shadowOpacity = 0.4
        startBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
        startBtn.layer.shadowRadius = CGFloat(5)
    }
    

    @IBAction func dismissTutorial() {
        self.dismiss(animated: true)
    }

}
