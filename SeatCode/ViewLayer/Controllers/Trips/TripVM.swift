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
    var stopPoints: [StopPinAnnotation]
    var polylinePoints: [CLLocationCoordinate2D] = []

    // MARK: - Constructor/Initializer
    init(trip: Trip) {

        self.driverName = trip.driverName
        self.startEnd = "\(trip.startTime) - \(trip.endTime)"
        self.originDestination = "\(trip.origin.address) - \(trip.destination.address)"
        var currentStopPoint = 0
        self.stopPoints = trip.stopPoints.map({
            let location = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            let stopPinAnnotation = StopPinAnnotation()
            stopPinAnnotation.title = trip.driverName
            if currentStopPoint == 0 {
                stopPinAnnotation.subtitle = R.string.localizable.trips_origin.key.localized
            } else if let identifier = $0.id {
                stopPinAnnotation.subtitle = R.string.localizable.trips_id_stop.key.localized + " \(identifier)"
            } else {
                stopPinAnnotation.subtitle = R.string.localizable.trips_destination.key.localized
            }
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                    longitude: location.coordinate.longitude)
            stopPinAnnotation.setCoordinate(newCoordinate: coordinate)
            currentStopPoint += 1
            return stopPinAnnotation
        })

        let polyline = Polyline(encodedPolyline: trip.polylineStr)
        if let decodedLocations = polyline.locations {
            polylinePoints = decodedLocations.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude,
                                                                           longitude: $0.coordinate.longitude) }
        }
    }
}
