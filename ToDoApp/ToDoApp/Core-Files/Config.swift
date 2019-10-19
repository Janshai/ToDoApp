//
//  Config.swift
//  ToDoApp
//
//  Created by Jack Adams on 05/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    public static let apiBaseURL = "https://pacific-wildwood-16643.herokuapp.com/"
    
    public static let categoryColours: [(name: CategoryColours, colour: UIColor)] =
        [(.white, #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),
         (.lightBlue, #colorLiteral(red: 0.5789950021, green: 0.9393020989, blue: 0.9686274529, alpha: 1)),
         (.darkBlue, #colorLiteral(red: 0.1640697514, green: 0.3524810569, blue: 0.9835421954, alpha: 1)),
         (.lightGreen, #colorLiteral(red: 0.5617556389, green: 0.9485365724, blue: 0.2991587594, alpha: 1)),
         (.darkGreen, #colorLiteral(red: 0.05715843846, green: 0.4862745106, blue: 0.09175236372, alpha: 1)),
         (.red, #colorLiteral(red: 0.9760731637, green: 0.1374234108, blue: 0, alpha: 1)),
         (.crimson, #colorLiteral(red: 0.7195828046, green: 0.1044110812, blue: 0.006150699003, alpha: 1)),
         (.pink, #colorLiteral(red: 0.9439835989, green: 0.5450249777, blue: 1, alpha: 1)),
         (.yellow, #colorLiteral(red: 0.9686274529, green: 0.9085301033, blue: 0.161269136, alpha: 1)),
         (.orange, #colorLiteral(red: 1, green: 0.6492510586, blue: 0.1451012835, alpha: 1)),
         (.violet, #colorLiteral(red: 0.8029299361, green: 0.5891632973, blue: 0.9686274529, alpha: 1)),
         (.purple, #colorLiteral(red: 0.3935294468, green: 0.2191077112, blue: 0.9686274529, alpha: 1)),
         (.brown, #colorLiteral(red: 0.6253172589, green: 0.4260899031, blue: 0.2733404623, alpha: 1)),
         (.grey, #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]
}

enum CategoryColours: String {
    case white = "White"
    case lightBlue = "Light Blue"
    case darkBlue = "Dark Blue"
    case lightGreen = "Light Green"
    case darkGreen = "Dark Green"
    case red = "Red"
    case crimson = "Crimson"
    case pink = "Pink"
    case yellow = "Yellow"
    case orange = "Orange"
    case violet = "Violet"
    case purple = "Purple"
    case brown = "Brown"
    case grey = "Grey"
}
