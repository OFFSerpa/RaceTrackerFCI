//
//  GeoJsonRouteManager.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 27/05/24.
//

import UIKit
import MapKit

class GeoJSONRouteManager {
    
    func loadGeoJSON(fileName: String) -> [MKOverlay]? {
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: "geojson") else {
            print("GeoJSON file not found.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: filePath)
            let geoJSON = try MKGeoJSONDecoder().decode(data)
            let overlays = geoJSON.compactMap { $0 as? MKGeoJSONFeature }.flatMap { $0.geometry }
            let mkOverlays = overlays.compactMap { $0 as? MKOverlay }
            return mkOverlays
        } catch {
            print("Error loading GeoJSON: \(error)")
            return nil
        }
    }
    
    // Método para calcular a distância de uma rota
    func calculateDistance(routePoints: [CLLocationCoordinate2D]) -> Double {
        var totalDistance: Double = 0
        for i in 1..<routePoints.count {
            let start = CLLocation(latitude: routePoints[i-1].latitude, longitude: routePoints[i-1].longitude)
            let end = CLLocation(latitude: routePoints[i].latitude, longitude: routePoints[i].longitude)
            totalDistance += start.distance(from: end)
        }
        return totalDistance / 1000  // Converter para quilômetros
    }
}
