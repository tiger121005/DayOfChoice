//
//  CustomCollectionViewCell.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/22.
//

import UIKit
import SwiftUI

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var graphView: UIView!
    @IBOutlet var rate1Label: UILabel!
    @IBOutlet var rate2Label: UILabel!
    @IBOutlet var star1View: UIImageView!
    @IBOutlet var star2View: UIImageView!
    
    var title1 = ""
    var title2 = ""
    var number1 = 0
    var number2 = 0
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let vc: UIHostingController = UIHostingController(rootView: PiChart(title1: title1, number1: number1, title2: title2, number2: number2))
        
        self.addChild(vc)
        graphView.addSubview(vc.view)
        vc.didMove(toParent: self)
        // UIView内で表示されているSwiftUIビューの位置とサイズなどを調整
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 0).isActive = true
        vc.view.leftAnchor.constraint(equalTo: graphView.leftAnchor, constant: 0).isActive = true
        vc.view.rightAnchor.constraint(equalTo: graphView.rightAnchor, constant: 0).isActive = true
    }

    
}
