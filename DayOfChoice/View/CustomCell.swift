//
//  CustomCell.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/07.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var myAnswerLabel: UILabel!
    
    @IBOutlet var matchView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        matchView.layer.cornerRadius = 5
        matchView.layer.cornerCurve = .continuous
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
