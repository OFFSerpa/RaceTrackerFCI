//
//  RoutePointModel.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 28/10/24.
//
import SwiftUI
import CoreLocation

class RoutePoint: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
    
    init(coordinate: CLLocationCoordinate2D, timestamp: Date) {
        self.coordinate = coordinate
        self.timestamp = timestamp
    }
}
