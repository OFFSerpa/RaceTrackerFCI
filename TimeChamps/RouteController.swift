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
    
    init(name: String, coordinates: [CLLocationCoordinate2D]) {
        self.name = name
        self.coordinates = coordinates
    }
}

class Routes {
    private(set) var allRoutes: [Route] = []
    
    func addRoute(name: String, coordinates: [CLLocationCoordinate2D]) {
        let newRoute = Route(name: name, coordinates: coordinates)
        allRoutes.append(newRoute)
    }
}
