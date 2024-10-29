//
//  Coordinator.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 29/10/24.
//

import MapKit
import SwiftUI

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapViewUI
    
    init(_ parent: MapViewUI) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

