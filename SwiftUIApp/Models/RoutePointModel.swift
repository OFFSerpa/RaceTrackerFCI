//
//  RoutePointModel.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 28/10/24.
//

import Foundation
import CoreLocation

struct RoutePointModel: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
}
