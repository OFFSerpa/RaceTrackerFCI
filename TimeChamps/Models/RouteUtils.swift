//
//  RouteUtils.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 05/05/25.
//


import CoreLocation

struct RouteUtils {
    static func calculateDistance(points: [RoutePoint]) -> Double {
        var total: Double = 0
        for i in 1..<points.count {
            let start = CLLocation(latitude: points[i-1].coordinate.latitude, longitude: points[i-1].coordinate.longitude)
            let end = CLLocation(latitude: points[i].coordinate.latitude, longitude: points[i].coordinate.longitude)
            total += start.distance(from: end)
        }
        return total / 1000
    }

    static func calculateBestTime(points: [RoutePoint]) -> String {
        guard let first = points.first, let last = points.last else { return "0'00\"" }
        let interval = last.timestamp.timeIntervalSince(first.timestamp)
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d'%02d\"", minutes, seconds)
    }
}