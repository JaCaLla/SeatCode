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
        
        let mapZoomEdgeInsets = UIEdgeInsets(top: 40.0, left: 30.0, bottom: 30.0, right: 30.0)
        setVisibleMapRect(polyline.boundingMapRect, edgePadding: mapZoomEdgeInsets, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension TripMap: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemIndigo.withAlphaComponent(0.8)
            renderer.lineWidth = 5
            return renderer
        }

        return MKOverlayRenderer()
    }
}
