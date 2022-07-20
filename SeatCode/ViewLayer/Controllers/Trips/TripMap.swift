//
//  TripMap.swift
//  SeatCode
//
//  Created by Javier Calatrava on 20/7/22.
//

import UIKit
import MapKit

class TripMap: MKMapView {

    // MARK: - Callbacks


    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Public methods
    func set(tripVM: TripVM) {
        isHidden = false

        removeAnnotations(self.annotations)
        addAnnotations(tripVM.stopPoints)
        updatePolyline(tripVM: tripVM)
    }


    // MARK: - Private methods
    private func setupView() {
        delegate = self
        isHidden = true
    }

    private func updatePolyline(tripVM: TripVM) {
        removeOverlays(overlays)
        let polyline = MKPolyline(coordinates: tripVM.polylinePoints, count: tripVM.polylinePoints.count)
        addOverlay(polyline)

        let mapZoomEdgeInsets = UIEdgeInsets(top: 50.0, left: 30.0, bottom: 30.0, right: 30.0)
        setVisibleMapRect(polyline.boundingMapRect, edgePadding: mapZoomEdgeInsets, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension TripMap: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let tripPolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: tripPolyline)
            renderer.strokeColor = UIColor.systemIndigo.withAlphaComponent(0.8)
            renderer.lineWidth = 5
            return renderer
        }

        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let stopPinAnnotation = annotation as? StopPinAnnotation else { return MKAnnotationView() }

        let reuseIdentifier = "pin"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? StopPinAnnotationView {
            annotationView.set(stopPinAnnotation: stopPinAnnotation)
            return annotationView
        } else {
            let annotationView = StopPinAnnotationView(stopPinAnnotation: stopPinAnnotation, reuseIdentifier: reuseIdentifier)
            annotationView.canShowCallout = false
            return annotationView
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is StopPinAnnotationView,
            let view = view as? StopPinAnnotationView else { return }
        view.setSelected(value: true)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard view is StopPinAnnotationView,
            let view = view as? StopPinAnnotationView else { return }
        view.setSelected(value: false)
    }
}
