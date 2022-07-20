//
//  PinAnnotationView.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import MapKit

class StopPinAnnotationView: MKAnnotationView {
    
    // MARK: - Public attributes
    var popup = PopUpAnnotation.instantiate()
    
    // MARK: - Private/Internal attributes
    private var stopView: UIView = UIView()
    
    // MARK: - Constructor/Initializer
    init(stopPinAnnotation: StopPinAnnotation, reuseIdentifier: String?) {
        super.init(annotation: stopPinAnnotation, reuseIdentifier: reuseIdentifier)
        setupView(stopPinAnnotation)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public methods
    func setSelected(value: Bool) {
        stopView.layer.borderColor = value ? UIColor.red.cgColor : UIColor.systemIndigo.withAlphaComponent(0.8).cgColor
        popup.isHidden = !value
    }
        
    func set(stopPinAnnotation: StopPinAnnotation) {
        self.annotation = stopPinAnnotation
        refreshView(stopPinAnnotation: stopPinAnnotation)
    }
    
    // MARK: - Private/Internal methods
    fileprivate func setupView(_ stopPinAnnotation: StopPinAnnotation) {
        stopView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15.0, height: 15.0))
        stopView.center = self.center
        stopView.layer.cornerRadius = stopView.layer.frame.size.width / 2
        stopView.layer.borderWidth = 5
        stopView.layer.borderColor = UIColor.systemIndigo.withAlphaComponent(0.8).cgColor
        stopView.backgroundColor = UIColor.white
        stopView.layer.masksToBounds = true
        self.addSubview(stopView)
        
        popup.set(pinAnnotation: stopPinAnnotation)
        popup.isHidden = true
        popup.frame.origin.x -= popup.frame.size.width / 2
        popup.frame.origin.y -= (popup.frame.size.height + 10)
        self.addSubview(popup)
    }
    
    fileprivate func refreshView(stopPinAnnotation: StopPinAnnotation) {
        popup.set(pinAnnotation: stopPinAnnotation)
    }
}
