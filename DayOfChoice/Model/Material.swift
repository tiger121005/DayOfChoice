//
//  Material.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/20.
//

import UIKit

struct Material {
    static let shared = Material()
    
    
    
//    let redGradient: [CGColor] = [CGColor(red: 1.0,
//                                          green: 79 / 255,
//                                          blue: 79 / 255,
//                                          alpha: 1.0),
//                                  CGColor(red: 1.0,
//                                          green: 208 / 255,
//                                          blue: 181 / 255,
//                                          alpha: 1.0)]
    let redGradient: [CGColor] = [UIColor.red.cgColor,
                                  CGColor(red: 1.0,
                                          green: 208 / 255,
                                          blue: 181 / 255,
                                          alpha: 1.0)]
    
//    let blueGradient: [CGColor] = [CGColor(red: 11 / 255,
//                                           green: 147 / 255,
//                                           blue: 244 / 255,
//                                           alpha: 1.0),
//                                   CGColor(red: 103 / 255,
//                                           green: 197 / 255,
//                                           blue: 231 / 255,
//                                           alpha: 1.0)]
    
    let blueGradient: [CGColor] = [UIColor.blue.cgColor, CGColor(red: 103 / 255,
                                                                 green: 197 / 255,
                                                                 blue: 231 / 255,
                                                                 alpha: 1.0)]
    
    let randomHours = [
        2, 7, 4, 3, 8, 1, 5, 6, 3, 8, 2, 7, 4, 1, 6, 5, 4, 1, 7, 3, 6, 2, 8, 5, 1,
        6, 3, 7, 2, 4, 8, 5, 3, 2, 8, 5, 7, 1, 6, 4, 7, 3, 8, 2, 4, 6, 5, 1, 4, 6,
        1, 7, 3, 5, 8, 2, 7, 6, 3, 4, 5, 2, 1, 8, 2, 6, 3, 8, 5, 1, 4, 7, 1, 4, 7,
        5, 3, 8, 2, 6, 1, 7, 5, 3, 2, 4, 6, 8, 7, 3, 6, 4, 2, 8, 5, 1, 8, 5, 2, 3,
        7, 1, 6, 4, 3, 2, 5, 8, 1, 4, 7, 6, 5, 4, 3, 7, 8, 2, 1, 6, 4, 8, 5, 3, 7,
        1, 2, 6, 7, 1, 5, 2, 4, 8, 3, 6, 8, 3, 6, 4, 7, 1, 5, 2, 3, 8, 7, 6, 7, 4,
        2, 1, 3, 4, 2, 5, 1, 7, 8, 6, 2, 5, 4, 3, 7, 1, 8, 6, 5, 4, 8, 1, 3, 7, 2,
        6, 3, 2, 7, 4, 1, 6, 5, 8, 3, 6, 4, 8, 2, 5, 1, 7, 4, 3, 1, 5, 7, 8, 2, 6,
        3, 8, 2, 1, 7, 5, 4, 6, 8, 7, 1, 3, 6, 2, 5, 4, 1, 7, 2, 8, 6, 4, 5, 3, 7,
        2, 3, 5, 8, 6, 4, 1, 5, 4, 6, 7, 3, 2, 1, 8, 7, 1, 4, 5, 8, 2, 6, 3, 4, 5,
        1, 8, 6, 7, 3, 2, 6, 4, 7, 8, 3, 2, 1, 5, 7, 8, 2, 3, 5, 1, 6, 4, 1, 3, 8,
        7, 4, 6, 5, 2, 6, 7, 4, 5, 3, 1, 2, 8, 7, 3, 1, 6, 8, 4, 5, 2, 6, 8, 3, 4,
        5, 1, 2, 7, 5, 2, 6, 8, 7, 4, 3, 1, 8, 1, 7, 6, 4, 3, 5, 2, 7, 5, 2, 1, 4,
        6, 8, 3, 2, 6, 4, 1, 5, 8, 3, 7, 4, 5, 3, 1, 8, 6, 2, 7, 1, 6, 5, 4, 8, 2,
        3, 7, 8, 5, 2, 6, 4, 1, 3, 2, 7, 5, 4, 8, 3, 6, 1, 7, 8, 6, 5, 3, 2, 4, 1,
        4, 8, 2, 7, 6, 3, 1, 5, 3, 6, 7, 4, 1, 5, 2, 8, 2, 5, 6, 3, 8, 7, 4, 1, 6,
        4, 3, 5, 7, 2, 1, 8, 5, 2, 6, 7, 1, 3, 8, 4, 3, 5, 8, 4, 2, 7, 6, 1, 2, 8,
        5, 3, 1, 6, 4, 7, 5, 4, 2, 6, 1, 7, 8, 3, 7, 3, 2, 4, 5, 8, 6, 1, 2, 7, 6,
        4, 3, 1, 5, 8, 5, 6, 3, 8, 1, 7, 4, 2, 8, 3, 5, 4, 1, 2, 6, 7, 1, 2, 3, 5,
        8, 7, 4, 6, 5, 1, 4, 8, 6, 3, 2, 7, 4, 3, 8, 5]
    
    let randomMinute = [4, 29, 53, 18, 8, 46, 5, 16, 43, 1, 38, 57, 9, 22, 49,
                        34, 56, 3, 21, 31, 11, 44, 20, 6, 39, 28, 15, 55, 27, 58,
                        12, 17, 48, 26, 7, 45, 51, 0, 32, 25, 14, 50, 19, 37, 54,
                        33, 10, 2, 47, 13, 36, 52, 30, 35, 24, 42, 23, 41, 59, 40,
                        1, 52, 16, 30, 11, 48, 17, 57, 39, 7, 5, 41, 29, 26, 35,
                        8, 44, 24, 12, 21, 54, 15, 56, 28, 10, 6, 0, 33, 19, 43,
                        51, 25, 47, 38, 22, 31, 46, 18, 37, 14, 53, 3, 50, 58, 2, 
                        9, 34, 27, 55, 45, 20, 4, 13, 32, 23, 40, 36, 42, 49, 38,
                        27, 50, 10, 7, 48, 13, 53, 41, 19, 33, 52, 15, 5, 9, 36,
                        26, 55, 23, 8, 1, 39, 30, 12, 46, 20, 58, 35, 11, 3, 44,
                        21, 16, 29, 56, 43, 25, 3, 6, 31, 22, 47, 17, 45, 24, 59,
                        32, 14, 54, 2, 40, 4, 37, 28, 51, 18, 34, 42, 50, 0, 7,
                        40, 57, 29, 6, 22, 14, 47, 59, 10, 49, 31, 18, 3, 24, 37,
                        13, 41, 55, 8, 28, 39, 16, 9, 54, 11, 32, 26, 58, 5, 43,
                        25, 2, 46, 17, 36, 20, 51, 1, 12, 45, 15, 38, 21, 4, 56, 
                        35, 27, 30, 53, 23, 19, 48, 44, 33, 52, 58, 13, 34, 25, 53,
                        48, 18, 14, 29, 50, 41, 38, 36, 56, 8, 10, 44, 21, 24, 5,
                        40, 28, 59, 47, 3, 17, 22, 12, 33, 35, 45, 11, 6, 39, 49,
                        31, 26, 2, 19, 16, 0, 30, 57, 15, 55, 43, 7, 4, 51, 37,
                        32, 54, 9, 1, 42, 46, 23, 27, 20, 52, 34, 32, 55, 14, 28,
                        41, 58, 1, 44, 4, 35, 38, 25, 8, 45, 29, 10, 6, 53, 40,
                        50, 24, 11, 54, 19, 18, 49, 21, 0, 39, 12, 33, 56, 17, 36,
                        2, 3, 16, 51, 27, 20, 57, 15, 26, 48, 31, 30, 59, 23, 7,
                        47, 5, 9, 37, 22, 42, 34, 43, 52, 13, 46, 58, 55, 14, 50,
                        33, 43, 21, 24, 29, 0, 11, 31, 4, 40, 51, 36, 15, 57, 9,
                        2, 20, 58, 7, 39, 8, 45, 27, 16, 53, 3, 47, 35, 44, 18, 
                        32, 19, 54, 5, 46, 41, 17, 30, 12, 56, 23, 48, 26, 37, 1,
                        38, 10, 59, 6, 22, 49, 34, 28, 52, 42, 13, 25, 50, 32, 5,
                        43, 46, 58, 15, 39, 22, 25, 34, 7, 55, 18, 11, 29, 48, 4,
                        0, 24, 51, 16, 38, 9, 31, 20, 53, 41, 3, 37, 12, 27, 10,
                        56, 23, 47, 19, 42, 17, 8, 28, 45, 35, 14, 59, 30, 2, 49,
                        33, 57, 26, 50, 6, 1, 40, 21, 52, 44, 36, 13, 3, 29, 20,
                        51, 17, 48, 42, 2, 11]
}
