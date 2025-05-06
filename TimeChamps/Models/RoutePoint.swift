//
//  RoutePoint.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 05/05/25.
//


import CoreLocation

class RoutePoint {
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
    
    init(coordinate: CLLocationCoordinate2D, timestamp: Date) {
        self.coordinate = coordinate
        self.timestamp = timestamp
    }
}