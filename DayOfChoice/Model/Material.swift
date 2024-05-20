//
//  Material.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/20.
//

import UIKit

struct Material {
    static let shared = Material()
    
    
    
    let redGradient: [CGColor] = [CGColor(red: 1.0,
                                          green: 79 / 255,
                                          blue: 79 / 255,
                                          alpha: 1.0),
                                  CGColor(red: 1.0,
                                          green: 208 / 255,
                                          blue: 181 / 255,
                                          alpha: 1.0)]
    
    let blueGradient: [CGColor] = [CGColor(red: 11 / 255,
                                           green: 147 / 255,
                                           blue: 244 / 255,
                                           alpha: 1.0),
                                   CGColor(red: 103 / 255,
                                           green: 197 / 255,
                                           blue: 231 / 255,
                                           alpha: 1.0)]
}
