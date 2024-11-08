//
//  RouteManager.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 29/10/24.
//


import SwiftUI
import MapKit

class RouteManager: ObservableObject {
    @Published var routePoints: [RoutePoint] = []
    
    func startNewRoute() {
        routePoints = []
    }
    
    func addCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let routePoint = RoutePoint(coordinate: coordinate, timestamp: Date())
        routePoints.append(routePoint)
    }
    
    func clearRoute() {
        routePoints.removeAll()
    }
    
    func loadGeoJSON(filePath: String) -> [MKPolyline] {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let geoJSON = try MKGeoJSONDecoder().decode(data)
            let polylines = geoJSON.compactMap { $0 as? MKGeoJSONFeature }.compactMap { feature -> MKPolyline? in
                guard let geometry = feature.geometry.first as? MKPolyline else { return nil }
                return geometry
            }
            return polylines
        } catch {
            print("Erro ao carregar GeoJSON: \(error)")
            return []
        }
    }
}