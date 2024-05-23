//
//  RouteController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//

import MapKit

class RoutePoint {
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
    
    init(coordinate: CLLocationCoordinate2D, timestamp: Date) {
        self.coordinate = coordinate
        self.timestamp = timestamp
    }
}

class Route {
    var name: String
    var points: [RoutePoint]
    var distance: Double
    var bestTime: String
    
    init(name: String, points: [RoutePoint], distance: Double, bestTime: String) {
        self.name = name
        self.points = points
        self.distance = distance
        self.bestTime = bestTime
    }
}

class Routes {
    private(set) var allRoutes: [Route] = []
    
    func addRoute(name: String, points: [RoutePoint]) {
        let distance = calculateDistance(points: points)
        let bestTime = calculateBestTime(points: points)
        let newRoute = Route(name: name, points: points, distance: distance, bestTime: bestTime)
        allRoutes.append(newRoute)
    }
    
    public func calculateDistance(points: [RoutePoint]) -> Double {
        var totalDistance: Double = 0
        for i in 1..<points.count {
            let start = CLLocation(latitude: points[i-1].coordinate.latitude, longitude: points[i-1].coordinate.longitude)
            let end = CLLocation(latitude: points[i].coordinate.latitude, longitude: points[i].coordinate.longitude)
            totalDistance += start.distance(from: end)
        }
        return totalDistance / 1000 
    }
    
    public func calculateBestTime(points: [RoutePoint]) -> String {
        guard let firstPoint = points.first, let lastPoint = points.last else {
            return "0'00\""
        }
        
        let timeInterval = lastPoint.timestamp.timeIntervalSince(firstPoint.timestamp)
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d'%02d\"", minutes, seconds)
    }
}
