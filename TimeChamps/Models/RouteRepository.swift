//
//  RouteRepository.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 05/05/25.
//


import MapKit

class RouteRepository {
    private(set) var allRoutes: [Route] = []
    
    func addRoute(name: String, points: [RoutePoint]) {
        let distance = RouteUtils.calculateDistance(points: points)
        let bestTime = RouteUtils.calculateBestTime(points: points)
        let route = Route(name: name, distance: distance, bestTime: bestTime, points: points)
        allRoutes.append(route)
    }

    func addGeoJSONRoute(name: String, overlays: [MKOverlay]) {
        var points: [RoutePoint] = []
        for overlay in overlays {
            if let polyline = overlay as? MKPolyline {
                for i in 0..<polyline.pointCount {
                    let coordinate = polyline.points()[i].coordinate
                    points.append(RoutePoint(coordinate: coordinate, timestamp: Date()))
                }
            }
        }
        addRoute(name: name, points: points)
    }

    func addGeoJSONFeatures(_ features: [MKGeoJSONFeature]) {
        for feature in features {
            guard let polyline = feature.geometry.first as? MKPolyline else { continue }

            let name: String = {
                if let data = feature.properties,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let n = json["name"] as? String {
                    return n
                }
                return "Rota Desconhecida"
            }()

            var points: [RoutePoint] = []
            for i in 0..<polyline.pointCount {
                let coord = polyline.points()[i].coordinate
                points.append(RoutePoint(coordinate: coord, timestamp: Date()))
            }

            addRoute(name: name, points: points)
        }
    }
    
    func addApiRoutes(_ pistas: [ApiPista]) {
        for pista in pistas {
            for feature in pista.geojson.features {
                let coords = feature.geometry.coordinates.map {
                    CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                }
                let polyline = MKPolyline(coordinates: coords, count: coords.count)

                var points: [RoutePoint] = []
                for i in 0..<polyline.pointCount {
                    let coord = polyline.points()[i].coordinate
                    points.append(RoutePoint(coordinate: coord, timestamp: Date()))
                }

                addRoute(name: pista.nome, points: points)
            }
        }
    }
    
    func addPolylines(_ polylines: [MKPolyline], named name: String = "Rota Desconhecida") {
        for polyline in polylines {
            var points: [RoutePoint] = []
            for i in 0..<polyline.pointCount {
                let coord = polyline.points()[i].coordinate
                points.append(RoutePoint(coordinate: coord, timestamp: Date()))
            }
            addRoute(name: name, points: points)
        }
    }
}
