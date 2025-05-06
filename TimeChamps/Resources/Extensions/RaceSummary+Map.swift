//
//  RaceSummary+Map.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 05/05/25.
//

import MapKit

extension RaceSummaryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .cyan
            renderer.lineWidth = 8
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
