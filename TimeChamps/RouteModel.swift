////
////  RouteController.swift
////  TimeChamps
////
////  Created by Vinicius Serpa on 21/05/24.
////
//
//import MapKit
//import CoreLocation
//
//class RoutePoint {
//    var coordinate: CLLocationCoordinate2D
//    var timestamp: Date
//    
//    init(coordinate: CLLocationCoordinate2D, timestamp: Date) {
//        self.coordinate = coordinate
//        self.timestamp = timestamp
//    }
//}
//
//class Route {
//    var name: String
//    var distance: Double
//    var bestTime: String
//    var points: [RoutePoint]
//    
//    var bestTimeInterval: TimeInterval? {
//        let components = bestTime.split(separator: ":").compactMap { Double($0) }
//        guard components.count == 2 else { return nil }
//        return (components[0] * 60) + components[1]
//    }
//    
//    init(name: String, distance: Double, bestTime: String, points: [RoutePoint]) {
//        self.name = name
//        self.distance = distance
//        self.bestTime = bestTime
//        self.points = points
//    }
//}
//
//class Routes {
//    private(set) var allRoutes: [Route] = []
//    
//    func addRoute(name: String, points: [RoutePoint]) {
//        let distance = calculateDistance(points: points)
//        let bestTime = calculateBestTime(points: points)
//        let newRoute = Route(name: name, distance: distance, bestTime: bestTime, points: points)
//        allRoutes.append(newRoute)
//    }
//
//    func addGeoJSONRoute(name: String, overlays: [MKOverlay]) {
//        var points: [RoutePoint] = []
//        for overlay in overlays {
//            if let polyline = overlay as? MKPolyline {
//                for i in 0..<polyline.pointCount {
//                    let coordinate = polyline.points()[i].coordinate
//                    let routePoint = RoutePoint(coordinate: coordinate, timestamp: Date())
//                    points.append(routePoint)
//                }
//            }
//        }
//        addRoute(name: name, points: points)
//    }
//    
//     func calculateDistance(points: [RoutePoint]) -> Double {
//        var totalDistance: Double = 0
//        for i in 1..<points.count {
//            let start = CLLocation(latitude: points[i-1].coordinate.latitude, longitude: points[i-1].coordinate.longitude)
//            let end = CLLocation(latitude: points[i].coordinate.latitude, longitude: points[i].coordinate.longitude)
//            totalDistance += start.distance(from: end)
//        }
//        return totalDistance / 1000
//    }
//
//     func calculateBestTime(points: [RoutePoint]) -> String {
//        guard let firstPoint = points.first, let lastPoint = points.last else {
//            return "0'00\""
//        }
//        let timeInterval = lastPoint.timestamp.timeIntervalSince(firstPoint.timestamp)
//        let minutes = Int(timeInterval) / 60
//        let seconds = Int(timeInterval) % 60
//        return String(format: "%d'%02d\"", minutes, seconds)
//    }
//}
