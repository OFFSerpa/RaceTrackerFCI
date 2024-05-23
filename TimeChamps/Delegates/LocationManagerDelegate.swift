//
//  LocationManagerDelegate.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//

import CoreLocation
import MapKit

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    weak var mapView: MKMapView?
    weak var viewController: AddViewController?
    weak var speedLabel: SpeedLabelView?
    let routeManager: RouteManager

    var isSaving: Bool = false

    init(mapView: MKMapView, viewController: AddViewController, speedLabel: SpeedLabelView, routeManager: RouteManager) {
        self.mapView = mapView
        self.viewController = viewController
        self.speedLabel = speedLabel
        self.routeManager = routeManager
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard let mapView = mapView else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)

        speedLabel?.updateSpeed(speed: location.speed)

        if isSaving {
            routeManager.addCoordinate(location.coordinate)
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
            routeManager.startNewRoute()
        }
        isSaving = true
    }

    func stopCurrentRoute() {
        if isSaving {
            isSaving = false
        }
    }
}
