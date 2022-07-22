//
//  AppColors.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//

import Foundation
import UIKit.UIColor

// App Colors

struct AppColors {

    struct Interface {
        static let white = UIColor(rgbaValue: 0xFFFFFFFF)
        static let black = UIColor(rgbaValue: 0x000000ff)
        static let lightBrown = UIColor(rgbaValue: 0xd9cbacff)
        static let whiteStained = UIColor(rgbaValue: 0xefefefFF)
        static let clear = UIColor.clear
        static let cement = UIColor(rgbaValue: 0x949493FF)
        static let blue = UIColor(rgbaValue: 0x007AFFFF)
        static let red = UIColor(rgbaValue: 0xff0000ff)
        static let green = UIColor(rgbaValue: 0x00ff00ff)
    }
    
    // MARK: - Trip
    struct Trip {
        static let issueFoundColor  = AppColors.Interface.red
        static let issueNotFoundColor  = AppColors.Interface.green
    }
    
    // MARK: - Issue
    struct Issue {
        static let firstFontColor   = AppColors.Interface.white
        static let emailFontColor   = AppColors.Interface.white
        static let background       = AppColors.Interface.black
        static let titleFontColor   = AppColors.Interface.white
    }

    // MARK: - PersonDetail
    struct PersonDetail {
        static let fontColor                = AppColors.Interface.black
        static let background               = AppColors.Interface.white
        static let buttonBackgroundColor    = AppColors.Interface.red
    }
}

extension UIColor {
    convenience init(rgbaValue: UInt32) {
        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

