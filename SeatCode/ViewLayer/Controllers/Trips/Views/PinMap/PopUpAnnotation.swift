//
//  PinAnnotation.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import Foundation
import UIKit

internal final class PopUpAnnotation: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblStartEnd: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Constructor/Initializer
    class func instantiate() -> PopUpAnnotation {
        let myClassNib = UINib(nibName: "PopUpAnnotation", bundle: nil)
        let popUpAnnotation = myClassNib.instantiate(withOwner: nil, options: nil)[0] as! PopUpAnnotation
        
        popUpAnnotation.containerView.layer.cornerRadius = 5
        popUpAnnotation.containerView.layer.borderWidth = 1
        popUpAnnotation.containerView.layer.borderColor = UIColor.systemIndigo.cgColor
        return popUpAnnotation
    }
    
    // MARK: - Public methdos
    func set(pinAnnotation: StopPinAnnotation) {
        lblDriverName.text = pinAnnotation.title
        lblStartEnd.text = pinAnnotation.subtitle
    }
}
