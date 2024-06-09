//
//  Material.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/20.
//

import UIKit

struct Material {
    static let shared = Material()
    
    
    let redGradient: [CGColor] = [UIColor.red.cgColor,
                                  CGColor(red: 1.0,
                                          green: 208 / 255,
                                          blue: 181 / 255,
                                          alpha: 1.0)]

    
    let blueGradient: [CGColor] = [UIColor.blue.cgColor, CGColor(red: 103 / 255,
                                                                 green: 197 / 255,
                                                                 blue: 231 / 255,
                                                                 alpha: 1.0)]
    
}
