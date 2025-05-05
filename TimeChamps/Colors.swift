//
//  Colors.swift
//  TimeChamps
//
//  Created by Raphael Iniesta Reis on 27/04/25.
//

import Foundation
import UIKit
import SwiftUI


extension UIColor {
    static let customBlue = UIColor(red: 15/255, green: 44/255, blue: 102/255, alpha: 1)
    static let customRed = UIColor(red: 206/255, green: 23/255, blue: 25/255, alpha: 1)
    static let customOrange = UIColor(red: 243/255, green: 149/255, blue: 13/255, alpha: 1)
    static let customYellow = UIColor(red: 1, green: 201/255, blue: 4/255, alpha: 1)
    
    static let backBlack = UIColor(red: 16/255, green: 23/255, blue: 29/255, alpha: 1)
    static let cardBlue = UIColor(red: 29/255, green: 80/255, blue: 118/255, alpha: 1)
    static let topBlue = UIColor(red: 21/255, green: 32/255, blue: 40/255, alpha: 1)
    
    // Cores frias
    static let coolWhite = UIColor(red: 207/255, green: 233/255, blue: 247/255, alpha: 1)
    static let coolBlue = UIColor(red: 50/255, green: 130/255, blue: 184/255, alpha: 1)
}

extension UIColor {
     static func dynamic(light: UIColor, dark: UIColor) -> UIColor {

         if #available(iOS 13.0, *) {
             return UIColor(dynamicProvider: {
                 switch $0.userInterfaceStyle {
                 case .dark:
                     return dark
                 case .light, .unspecified:
                     return light
                 @unknown default:
                     assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                     return light
                     
                 }
             })
         }
         return light
     }
}
