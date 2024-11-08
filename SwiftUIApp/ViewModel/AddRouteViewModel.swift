//
//  AddRouteViewModel.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 29/10/24.
//


import SwiftUI
import MapKit
import CoreLocation

class AddRouteViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isSaving: Bool = false
    @Published var currentSpeed: CLLocationSpeed = 0
    @Published var routePoints: [RoutePointModel] = []
    @Published var authorizationStatus: CLAuthorizationStatus

    var locationManager: CLLocationManager
    var routeManager: RouteManager
    var routes: Routes

    init(routes: Routes) {
        self.routes = routes
        self.routeManager = RouteManager(mapView: nil)
        self.locationManager = CLLocationManager()
        self.authorizationStatus = locationManager.authorizationStatus

        super.init()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }

    func toggleSaving() {
        isSaving.toggle()
        if isSaving {
            routeManager.startNewRoute()
            routePoints = []
        } else {
            // Salvar a rota
            showSaveRouteScreen()
        }
    }

    func showSaveRouteScreen() {
        // Lógica para salvar a rota
        // Você pode atualizar `routes` aqui com os novos pontos da rota
        routes.addRoute(name: "Nova Rota", points: routePoints)
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentSpeed = location.speed
        if isSaving {
            let routePoint = RoutePointModel(coordinate: location.coordinate, timestamp: Date())
            routePoints.append(routePoint)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao atualizar localização: \(error.localizedDescription)")
    }
}
