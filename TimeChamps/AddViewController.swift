//
//  AddViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 15/05/24.
//

import UIKit
import MapKit

class AddViewController: UIViewController, MKMapViewDelegate {
    
    var locationManager: CLLocationManager?
    var locationManagerDelegate: LocationManagerDelegate?
    
    var polylines: [MKPolyline] = []
    var routeCoordinates: [CLLocationCoordinate2D] = []
    var currentPolyline: MKPolyline?
    
    let speedLabel = SpeedLabelView()
    let routes: Routes
    
    init(routes: Routes) {
        self.routes = routes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSaving: Bool = false {
        didSet {
            locationManagerDelegate?.isSaving = isSaving
            updateButtonTitle()
            if isSaving {
                startNewRoute()
            } else {
                showSaveRouteScreen()
            }
        }
    }
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gravar Rota", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleSaving), for: .touchUpInside)
        return button
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(speedLabel)
        view.addSubview(startButton)
        
        setConstraints()
        
        self.view.backgroundColor = UIColor.secondarySystemBackground
        self.navigationItem.title = "Novo Percurso"
        
        updateButtonTitle()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManagerDelegate = LocationManagerDelegate(mapView: mapView, viewController: self, speedLabel: speedLabel)
        locationManager?.delegate = locationManagerDelegate
        
        locationManager?.startUpdatingLocation()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        mapView.userTrackingMode = .followWithHeading
        mapView.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            speedLabel.widthAnchor.constraint(equalToConstant: 100),
            speedLabel.heightAnchor.constraint(equalToConstant: 100),
            speedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            speedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            
            startButton.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 40),
            startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 118),
            startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -119)
        ])
    }
    
    private func updateButtonTitle() {
        let title = isSaving ? "Finalizar" : "Gravar Rota"
        startButton.setTitle(title, for: .normal)
        
        let color = isSaving ? UIColor.red : UIColor.green
        startButton.backgroundColor = color
    }
    
    @objc private func toggleSaving() {
        isSaving.toggle()
    }
    
    private func startNewRoute() {
        routeCoordinates = []
        currentPolyline = nil
    }
    
    private func showSaveRouteScreen() {
        let saveRouteVC = SaveRouteViewController()
        saveRouteVC.routes = routes
        saveRouteVC.routeCoordinates = routeCoordinates
        saveRouteVC.modalPresentationStyle = .fullScreen
        saveRouteVC.onSave = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        present(saveRouteVC, animated: true, completion: nil)
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func addPolyline() {
        guard routeCoordinates.count > 1 else { return }
        if let polyline = currentPolyline {
            mapView.removeOverlay(polyline)
        }
        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        mapView.addOverlay(polyline)
        currentPolyline = polyline
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if isSaving {
            routeCoordinates.append(location.coordinate)
            addPolyline()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

#Preview {
    AddViewController(routes: Routes())
}
