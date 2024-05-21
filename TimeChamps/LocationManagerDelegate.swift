//
//  LocationManagerDelegate.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//

import Foundation
import MapKit

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    weak var mapView: MKMapView?
    weak var viewController: AddViewController?
    
    var currentRouteCoordinates: [CLLocationCoordinate2D] = []
    var isSaving: Bool = false

    init(mapView: MKMapView, viewController: AddViewController) {
        self.mapView = mapView
        self.viewController = viewController
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocaitons locations: [CLLocation]) {
        guard let location = locations.last else {return}
        guard let mapView = mapView else {return}
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
        
        viewController?.updateSpeedLabel(speed: location.speed)
        
        if isSaving {
            currentRouteCoordinates.append(location.coordinate)
            viewController?.routeCoordinates.append(location.coordinate)
            
            if let polyline = viewController?.currentPolyline {
                mapView.removeOverlay(polyline)
            }
            
            viewController?.currentPolyline = createPolyline()
            mapView.addOverlay(viewController!.currentPolyline!)
        }

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewController?.checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }
    
    func startNewRoute() {
        if isSaving {
            currentRouteCoordinates = []
        }
        isSaving = true
    }

    func stopCurrentRoute() {
        if isSaving {
            isSaving = false
        }
    }
    
    
    private func createPolyline() -> MKPolyline {
        return MKPolyline(coordinates: currentRouteCoordinates, count: currentRouteCoordinates.count)
    }
    
}
