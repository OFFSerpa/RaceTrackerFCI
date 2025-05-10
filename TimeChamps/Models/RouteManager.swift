////
////  RouteManager.swift
////  TimeChamps
////
////  Created by Vinicius Serpa on 26/04/25.
////
//

import Foundation
import MapKit

class RouteManager {
    var routePoints: [RoutePoint] = []
    var currentPolyline: MKPolyline?
    var mapView: MKMapView?

    init(mapView: MKMapView? = nil) {
        self.mapView = mapView
    }

    func startNewRoute() {
        routePoints = []
        removeCurrentPolyline()
    }

    func addCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let routePoint = RoutePoint(coordinate: coordinate, timestamp: Date())
        routePoints.append(routePoint)
        addPolyline()
    }

    private func addPolyline() {
        guard routePoints.count > 1 else { return }
        removeCurrentPolyline()

        let coordinates = routePoints.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView?.addOverlay(polyline)
        currentPolyline = polyline
    }

    func polylineRenderer(overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    func clearRoute() {
        routePoints.removeAll()
        removeCurrentPolyline()
    }

    private func removeCurrentPolyline() {
        if let polyline = currentPolyline {
            mapView?.removeOverlay(polyline)
            currentPolyline = nil
        }
    }

    func fetchRoutesFromAPI(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error)")
                return
            }

            guard let data = data else {
                print("Sem dados na resposta")
                return
            }

            let polylines = self.parsePolylines(from: data)
            DispatchQueue.main.async {
                polylines.forEach { self.mapView?.addOverlay($0) }
            }
        }

        task.resume()
    }

    private func parsePolylines(from data: Data) -> [MKPolyline] {
        var polylines: [MKPolyline] = []

        struct ApiResponse: Decodable {
            struct GeoJSON: Decodable {
                struct Feature: Decodable {
                    struct Geometry: Decodable {
                        let coordinates: [[Double]]
                    }
                    let geometry: Geometry
                }
                let features: [Feature]
            }
            struct Pista: Decodable {
                let nome: String
                let geojson: GeoJSON
            }
            let pistas: [Pista]
        }

        do {
            let decoded = try JSONDecoder().decode(ApiResponse.self, from: data)
            for pista in decoded.pistas {
                for feature in pista.geojson.features {
                    let coords = feature.geometry.coordinates.map {
                        CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                    }
                    let polyline = MKPolyline(coordinates: coords, count: coords.count)
                    polylines.append(polyline)
                }
            }
        } catch {
            print("Erro ao decodificar JSON da API: \(error)")
        }

        return polylines
    }
}
