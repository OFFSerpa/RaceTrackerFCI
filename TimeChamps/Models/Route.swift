//
//  Route.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 05/05/25.
//

import Foundation

class Route {
    var name: String
    var distance: Double
    var bestTime: String
    var points: [RoutePoint]
    
    var bestTimeInterval: TimeInterval? {
        let components = bestTime.split(separator: ":").compactMap { Double($0) }
        guard components.count == 2 else { return nil }
        return (components[0] * 60) + components[1]
    }
    
    init(name: String, distance: Double, bestTime: String, points: [RoutePoint]) {
        self.name = name
        self.distance = distance
        self.bestTime = bestTime
        self.points = points
    }
}
