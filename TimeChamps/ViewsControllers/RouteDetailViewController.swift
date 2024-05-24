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
    var locationManager: CLLocationManager?
    var locationManagerDelegate: LocationManagerDelegate?
    var timer: Timer?
    var startTime: Date?
    var isRunning: Bool = false {
        didSet {
            updateButtonTitle()
        }
    }
    
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.italicSystemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mapViewComponent: MapViewComponent = {
        let mapView = MapViewComponent()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let startRaceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Correr!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemGreen
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startRace), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        setupUI()
        setupRouteDetails()
        configureLocationManager()
    }
    
    private func setupUI() {
        [titleLabel, distanceLabel, bestTimeLabel, timeLabel, mapViewComponent, startRaceButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bestTimeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10),
            bestTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: bestTimeLabel.bottomAnchor, constant: 10),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mapViewComponent.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            mapViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapViewComponent.bottomAnchor.constraint(equalTo: startRaceButton.topAnchor, constant: -25),
            
            startRaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 118),
            startRaceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -119),
            startRaceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startRaceButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupRouteDetails() {
        guard let route = route else { return }
        
        titleLabel.text = route.name
        distanceLabel.text = "Distância: \(formatDistance(route.distance)) km"
        bestTimeLabel.text = "Melhor Tempo: \(route.bestTime)"
        
        mapViewComponent.routePoints = route.points
        adjustMapZoom()
    }
    
    private func formatDistance(_ distance: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: distance)) ?? "\(distance)"
    }
    
    private func adjustMapZoom() {
        guard let coordinates = route?.points.map({ $0.coordinate }) else { return }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapViewComponent.mapView.addOverlay(polyline)
        
        var regionRect = polyline.boundingMapRect
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25
        
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        
        mapViewComponent.mapView.setVisibleMapRect(regionRect, animated: true)
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManagerDelegate = LocationManagerDelegate(mapView: mapViewComponent.mapView, viewController: self, routeManager: RouteManager(mapView: mapViewComponent.mapView))
        locationManagerDelegate?.onFinish = { [weak self] in
            self?.stopRace()
        }
        locationManagerDelegate?.configureLocationManager(locationManager!)
        locationManager?.delegate = locationManagerDelegate
    }
    
    @objc private func startRace() {
        if isRunning {
            stopRace()
        } else {
            startTime = Date()
            startTimer()
            locationManagerDelegate?.isSaving = true
            
            guard let finishCoordinate = route?.points.last?.coordinate else { return }
            locationManagerDelegate?.setupFinishLineRegion(coordinate: finishCoordinate)
            
            isRunning = true
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimeLabel() {
        guard let startTime = startTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timeLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func updateButtonTitle() {
        let title = isRunning ? "Finalizar" : "Correr!"
        startRaceButton.setTitle(title, for: .normal)
        
        let color = isRunning ? UIColor.systemRed : UIColor.systemGreen
        startRaceButton.backgroundColor = color
    }
    
    private func stopRace() {
        locationManagerDelegate?.isSaving = false
        timer?.invalidate()
        timer = nil
        isRunning = false
        
        let elapsedTime = Date().timeIntervalSince(startTime ?? Date())
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let timeString = String(format: "%d:%02d", minutes, seconds)
        
        let alert = UIAlertController(title: "Corrida Finalizada", message: "Você completou a corrida em \(timeString).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapViewComponent.mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

#Preview {
    RouteDetailViewController()
}
