//
//  File.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 23/05/24.
//

import UIKit
import MapKit

class MapViewComponent: UIView, MKMapViewDelegate {
    
    private(set) var mapView: MKMapView
    
    var routePoints: [RoutePoint] = [] {
        didSet {
            updateMap()
        }
    }
    
    override init(frame: CGRect) {
        mapView = MKMapView()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        mapView = MKMapView()
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func updateMap() {
        mapView.removeOverlays(mapView.overlays)
        let coordinates = routePoints.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        mapView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .cyan
            renderer.lineWidth = 7
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
