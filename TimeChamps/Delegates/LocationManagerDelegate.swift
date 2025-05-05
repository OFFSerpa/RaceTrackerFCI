//
//  LocationManagerDelegate.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 27/04/25.
//

import CoreLocation
import MapKit

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    weak var mapView: MKMapView?
    weak var viewController: UIViewController?
    weak var speedLabel: SpeedLabelView?
    let routeManager: RouteManager

    var isSaving: Bool = false
    var onFinish: (() -> Void)?
    var finishLineCoordinate: CLLocationCoordinate2D?
    var finishLineRegion: CLCircularRegion?

    init(mapView: MKMapView, viewController: UIViewController, speedLabel: SpeedLabelView? = nil, routeManager: RouteManager) {
        self.mapView = mapView
        self.viewController = viewController
        self.speedLabel = speedLabel
        self.routeManager = routeManager
    }

    func configureLocationManager(_ locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard let mapView = mapView else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)

        speedLabel?.updateSpeed(speed: location.speed)

        if isSaving {
            routeManager.addCoordinate(location.coordinate)
            checkFinishLineProximity(location)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if let addVC = viewController as? AddViewController {
            addVC.checkLocationAuthorization()
        } else if let routeDetailVC = viewController as? RouteDetailViewController {
            routeDetailVC.checkLocationAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == "FinishLine" {
            isSaving = false
            onFinish?()
        }
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

    func setupFinishLineRegion(coordinate: CLLocationCoordinate2D) {
        finishLineCoordinate = coordinate
        finishLineRegion = CLCircularRegion(center: coordinate, radius: 7, identifier: "FinishLine")
        finishLineRegion?.notifyOnEntry = true
    }

    private func checkFinishLineProximity(_ location: CLLocation) {
        guard let finishLineCoordinate = finishLineCoordinate else { return }
        let finishLineLocation = CLLocation(latitude: finishLineCoordinate.latitude, longitude: finishLineCoordinate.longitude)
        let distanceToFinishLine = location.distance(from: finishLineLocation)
        
        if distanceToFinishLine < 7 {
            isSaving = false
            onFinish?()
        }
    }
}
