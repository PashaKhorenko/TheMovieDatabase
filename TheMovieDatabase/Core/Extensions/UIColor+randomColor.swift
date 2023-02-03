//
//  UIColor+randomColor.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 03.02.2023.
//

import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1
        )
    }
}
