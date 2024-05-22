//
//  RouteController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//

import Foundation
import CoreLocation

class Route {
    var name: String
    var coordinates: [CLLocationCoordinate2D]
    var distance: Double
    var bestTime: String
    
    init(name: String, coordinates: [CLLocationCoordinate2D], distance: Double, bestTime: String) {
        self.name = name
        self.name = name
        self.coordinates = coordinates
        self.distance = distance
        self.bestTime = bestTime
        }
    }

    class Routes {
        private(set) var allRoutes: [Route] = []
        
        func addRoute(name: String, coordinates: [CLLocationCoordinate2D]) {
            let distance = calculateDistance(coordinates: coordinates)
            let bestTime = calculateBestTime(coordinates: coordinates)
            let newRoute = Route(name: name, coordinates: coordinates, distance: distance, bestTime: bestTime)
            allRoutes.append(newRoute)
        }
        
        private func calculateDistance(coordinates: [CLLocationCoordinate2D]) -> Double {
            var totalDistance: Double = 0
            for i in 1..<coordinates.count {
                let start = CLLocation(latitude: coordinates[i-1].latitude, longitude: coordinates[i-1].longitude)
                let end = CLLocation(latitude: coordinates[i].latitude, longitude: coordinates[i].longitude)
                totalDistance += start.distance(from: end)
            }
            return totalDistance / 1000 // Convert to kilometers
        }
        
        private func calculateBestTime(coordinates: [CLLocationCoordinate2D]) -> String {
            // Placeholder implementation for the best time calculation
            // This would be replaced with the actual logic to calculate the best time
            return "1'38\""
        }
    }
