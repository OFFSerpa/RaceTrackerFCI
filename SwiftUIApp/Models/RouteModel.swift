//
//  RouteModel.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 29/10/24.
//

import Foundation

struct RouteModel: Identifiable {
    let id = UUID()
    var name: String
    var distance: Double
    var bestTime: String
    var points: [RoutePointModel]
    
    var bestTimeInterval: TimeInterval? {
        let components = bestTime.split(separator: ":").compactMap { Double($0) }
        guard components.count == 2 else { return nil }
        return (components[0] * 60) + components[1]
    }
}
