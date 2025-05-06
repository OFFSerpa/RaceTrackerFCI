////
////  RouteManager.swift
////  TimeChamps
////
////  Created by Vinicius Serpa on 26/04/25.
////
//

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

    func loadGeoJSON(fromFileNamed fileName: String) -> [MKPolyline] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "geojson") else {
            print("❌ GeoJSON não encontrado: \(fileName)")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let geoJSON = try MKGeoJSONDecoder().decode(data)
            return geoJSON
                .compactMap { $0 as? MKGeoJSONFeature }
                .compactMap { $0.geometry.first as? MKPolyline }
        } catch {
            print("❌ Erro ao carregar GeoJSON: \(error)")
            return []
        }
    }
}
