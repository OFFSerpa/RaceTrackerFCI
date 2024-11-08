////
////  RouteManager.swift
////  TimeChamps
////
////  Created by Vinicius Serpa on 22/05/24.
////
//
//import MapKit
//
//class RouteManager {
//    var routePoints: [RoutePoint] = []
//    var currentPolyline: MKPolyline?
//    var mapView: MKMapView?
//
//    init(mapView: MKMapView?) {
//        self.mapView = mapView
//    }
//
//    func startNewRoute() {
//        routePoints = []
//        currentPolyline = nil
//    }
//
//    func addCoordinate(_ coordinate: CLLocationCoordinate2D) {
//        let routePoint = RoutePoint(coordinate: coordinate, timestamp: Date())
//        routePoints.append(routePoint)
//        addPolyline()
//    }
//
//    func addPolyline() {
//        guard routePoints.count > 1 else { return }
//        if let polyline = currentPolyline {
//            mapView?.removeOverlay(polyline)
//        }
//        let coordinates = routePoints.map { $0.coordinate }
//        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//        mapView?.addOverlay(polyline)
//        currentPolyline = polyline
//    }
//
//    func polylineRenderer(overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .blue
//            renderer.lineWidth = 4
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//
//    func clearRoute() {
//        routePoints.removeAll()
//        if let polyline = currentPolyline {
//            mapView?.removeOverlay(polyline)
//            currentPolyline = nil
//        }
//    }
//    
//    func loadGeoJSON(filePath: String) -> [MKOverlay]? {
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
//            let geoJSON = try MKGeoJSONDecoder().decode(data)
//            let overlays = geoJSON.compactMap { $0 as MKGeoJSONObject }.flatMap { geoJSONObject -> [MKOverlay] in
//                if let feature = geoJSONObject as? MKGeoJSONFeature, let geometry = feature.geometry.first {
//                    if let polyline = geometry as? MKPolyline {
//                        return [polyline]
//                    }
//                }
//                return []
//            }
//            return overlays
//        } catch {
//            print("Error loading GeoJSON: \(error)")
//            return nil
//        }
//    }
//}
