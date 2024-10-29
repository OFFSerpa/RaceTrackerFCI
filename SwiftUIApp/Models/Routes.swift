//
//  Routes.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 29/10/24.
//


import Foundation
import SwiftUI
import MapKit

class Routes: ObservableObject {
    @Published private(set) var allRoutes: [RouteModel] = []
    
    func addRoute(name: String, points: [RoutePointModel]) {
        let distance = calculateDistance(points: points)
        let bestTime = calculateBestTime(points: points)
        let newRoute = RouteModel(name: name, distance: distance, bestTime: bestTime, points: points)
        allRoutes.append(newRoute)
    }

    func addGeoJSONRoute(name: String, overlays: [MKOverlay]) {
        var points: [RoutePointModel] = []
        for overlay in overlays {
            if let polyline = overlay as? MKPolyline {
                for i in 0..<polyline.pointCount {
                    let coordinate = polyline.points()[i].coordinate
                    let routePoint = RoutePointModel(coordinate: coordinate, timestamp: Date())
                    points.append(routePoint)
                }
            }
        }
        addRoute(name: name, points: points)
    }
    
    private func calculateDistance(points: [RoutePointModel]) -> Double {
        var totalDistance: Double = 0
        for i in 1..<points.count {
            let start = CLLocation(latitude: points[i-1].coordinate.latitude, longitude: points[i-1].coordinate.longitude)
            let end = CLLocation(latitude: points[i].coordinate.latitude, longitude: points[i].coordinate.longitude)
            totalDistance += start.distance(from: end)
        }
        return totalDistance / 1000 
    }

    private func calculateBestTime(points: [RoutePointModel]) -> String {
        guard let firstPoint = points.first, let lastPoint = points.last else {
            return "0:00"
        }
        let timeInterval = lastPoint.timestamp.timeIntervalSince(firstPoint.timestamp)
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
