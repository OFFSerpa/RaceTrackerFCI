//
//  RouteDetailViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 27/04/25.
//


import UIKit
import MapKit
import SwiftUI

class RouteDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let speedLabel = SpeedLabelView()
    var route: Route
    var locationManager: CLLocationManager?
    var locationManagerDelegate: LocationManagerDelegate?
    var timer: Timer?
    var startTime: Date?
    var startCoordinate: CLLocationCoordinate2D?
    
    var lapCount: Int = 0 {
        didSet { lapsLabel.text = "Voltas: \(lapCount)" }
    }
    
    var isRunning: Bool = false {
        didSet { updateButtonState() }
    }

    // MARK: - UI Elements
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.italicSystemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lapsLabel: UILabel = {
        let label = UILabel()
        label.text = "Voltas: 0"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mapViewComponent: MapViewComponent = {
        let mapView = MapViewComponent()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var startRaceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ir!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemGreen
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleRace), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    
    init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        setupUI()
        populateRouteDetails()
        configureLocationManager()
    }

    // MARK: - Setup

    private func setupUI() {
        [titleLabel, distanceLabel, timeLabel, lapsLabel, mapViewComponent, startRaceButton, speedLabel].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lapsLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            lapsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            speedLabel.widthAnchor.constraint(equalToConstant: 100),
            speedLabel.heightAnchor.constraint(equalToConstant: 100),
            speedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            speedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            
            mapViewComponent.topAnchor.constraint(equalTo: lapsLabel.bottomAnchor, constant: 20),
            mapViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapViewComponent.bottomAnchor.constraint(equalTo: startRaceButton.topAnchor, constant: -25),
            
            startRaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 118),
            startRaceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -119),
            startRaceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startRaceButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func populateRouteDetails() {
        titleLabel.text = route.name
        distanceLabel.text = "Distância: \(String(format: "%.2f", route.distance)) km"
        
        mapViewComponent.routePoints = route.points
        adjustMapZoom()
    }

    private func adjustMapZoom() {
        let coordinates = route.points.map { $0.coordinate }
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
        let routeMgr = RouteManager(mapView: mapViewComponent.mapView)
        locationManagerDelegate = LocationManagerDelegate(
            mapView: mapViewComponent.mapView,
            viewController: self,
            speedLabel: speedLabel,
            routeManager: routeMgr
        )
        locationManagerDelegate?.onFinish = { [weak self] in self?.completeLap() }
        locationManagerDelegate?.configureLocationManager(locationManager!)
        locationManager?.delegate = locationManagerDelegate
    }

    // MARK: - Race Methods

    @objc private func toggleRace() {
        isRunning ? stopRace() : beginRace()
    }

    private func beginRace() {
        startTime = Date()
        lapCount = 0
        startTimer()
        locationManagerDelegate?.isSaving = true

        if let startCoord = route.points.first?.coordinate {
            self.startCoordinate = startCoord
            locationManagerDelegate?.setupFinishLineRegion(coordinate: startCoord)
        }

        isRunning = true
    }

    private func stopRace() {
        locationManagerDelegate?.isSaving = false
        timer?.invalidate()
        timer = nil
        isRunning = false

        let summaryVC = RaceSummaryViewController()
        summaryVC.route = route
        summaryVC.elapsedTime = Date().timeIntervalSince(startTime ?? Date())
        summaryVC.lapCount = lapCount
        navigationController?.pushViewController(summaryVC, animated: true)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }

    @objc private func updateTimeLabel() {
        if let start = startTime {
            timeLabel.text = Date().timeIntervalSince(start).formattedTime
        }
    }

    private func updateButtonState() {
        let title = isRunning ? "Parar!" : "Ir!"
        startRaceButton.setTitle(title, for: .normal)
        startRaceButton.backgroundColor = isRunning ? .systemRed : .systemGreen
    }

    private func completeLap() {
        lapCount += 1
    }

    // MARK: - CoreLocation Request

    func checkLocationAuthorization() {
        guard let manager = locationManager else { return }
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapViewComponent.mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        case .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            break
        @unknown default:
            break
        }
    }
}
