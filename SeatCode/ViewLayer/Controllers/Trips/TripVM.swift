//
//  RouteVM.swift
//  SeatCode
//
//  Created by Javier Calatrava on 19/7/22.
//

import Foundation
import MapKit
import Polyline

struct TripVM {
    var driverName: String
    var startEnd: String
    var originDestination: String
    var stopPoints:[MKPointAnnotation]
    var polylinePoints: [CLLocationCoordinate2D] = []
    
    // MARK: - Constructor/Initializer
    init(trip: Trip) {

        self.driverName = trip.driverName
        self.startEnd = "\(trip.startTime) - \(trip.endTime)"
        self.originDestination = "\(trip.origin.address) - \(trip.destination.address)"
        self.stopPoints = trip.stopPoints.map({
            let location = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                longitude: location.coordinate.longitude)
            return pointAnnotation
        })
        
        let polyline = Polyline(encodedPolyline: trip.route)
        if let decodedLocations = polyline.locations {
            polylinePoints = decodedLocations.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude,
                                                                      longitude: $0.coordinate.longitude)}
        }
    }
}
