//
//  PinAnnotation.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import Foundation
import MapKit

class StopPinAnnotation: NSObject, MKAnnotation {

    // MARK: - Private/Internal attributes
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var _title: String = String("")
    private var _subtitle: String = String("")

    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }

    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }

    var title: String? {
        get {
            return _title
        }
        set (value) {
            guard let value = value else { return }
            self._title = value
        }
    }

    var subtitle: String? {
        get {
            return _subtitle
        }
        set (value) {
            self._subtitle = value!
        }
    }
}
