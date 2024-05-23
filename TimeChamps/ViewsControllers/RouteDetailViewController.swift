//
//  RouteDetailViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 22/05/24.
//

import Foundation
import UIKit
import MapKit

class RouteDetailViewController: UIViewController {
    
    var route: Route?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        setupUI()
        setupFuncs()
        mapView.delegate = self
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(distanceLabel)
        view.addSubview(bestTimeLabel)
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bestTimeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10),
            bestTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mapView.topAnchor.constraint(equalTo: bestTimeLabel.bottomAnchor, constant: 150),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ])
    }
    
    
    
    private func setupFuncs() {
        guard let route = route else { return }
        
        titleLabel.text = route.name
        distanceLabel.text = "Distância: \(formatDistance(route.distance)) km"
        bestTimeLabel.text = "Melhor Tempo: \(route.bestTime)"
        
        let coordinates = route.points.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        mapView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
    }
    
    private func formatDistance(_ distance: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: distance)) ?? "\(distance)"
    }
}


#Preview {
    RouteDetailViewController()
}


