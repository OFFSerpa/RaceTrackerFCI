////
////  UiFontExtension.swift
////  TimeChamps
////
////  Created by Vinicius Serpa on 27/04/25.
////
//
//import Foundation
//import UIKit
//import MapKit
//
//extension UIFont {
//    class func italicSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
//        let font = UIFont.systemFont(ofSize: size, weight: weight)
//        switch weight {
//        case .ultraLight, .light, .thin, .regular:
//            return font.withTraits(.traitItalic, ofSize: size)
//        case .medium, .semibold, .bold, .heavy, .black:
//            return font.withTraits(.traitBold, .traitItalic, ofSize: size)
//        default:
//            return UIFont.italicSystemFont(ofSize: size)
//        }
//    }
//    
//    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits..., ofSize size: CGFloat) -> UIFont {
//        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
//        return UIFont(descriptor: descriptor!, size: size)
//    }
//}
//
//
//
//extension RouteDetailViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .blue
//            renderer.lineWidth = 4
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//}
//
//
//extension RaceSummaryViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .cyan
//            renderer.lineWidth = 8
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//}
//
// extension MKPolyline {
//    var coordinates: [CLLocationCoordinate2D] {
//        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: self.pointCount)
//        self.getCoordinates(&coords, range: NSRange(location: 0, length: self.pointCount))
//        return coords
//    }
//}
