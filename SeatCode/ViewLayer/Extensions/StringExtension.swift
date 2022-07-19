//
//  StringExtension.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
import UIKit

extension String {

    var localized: String {

        return NSLocalizedString(self,
                                 tableName: nil,
                                 bundle: Bundle.main ,
                                 value: "",
                                 comment: "")
    }
}
