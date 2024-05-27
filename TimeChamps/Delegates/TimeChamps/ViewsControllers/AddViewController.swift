//
//  AddViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 15/05/24.
//

import UIKit
import MapKit

class AddViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var locationManagerDelegate: LocationManagerDelegate?
    let routeManager: RouteManager
    let speedLabel = SpeedLabelView()
    let routes: Routes
    
    let mapViewComponent = MapViewComponent()
    
    init(routes: Routes) {
        self.routes = routes
        self.routeManager = RouteManager(mapView: nil)
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
                routeManager.startNewRoute()
            } else {
                showSaveRouteScreen()
            }
        }
    }
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gravar Rota", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemGreen
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleSaving), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routeManager.mapView = mapViewComponent.mapView
        configureLocationManager()
        setupUI()
        
    }
    
    private func setupUI() {
        view.addSubview(mapViewComponent)
        view.addSubview(speedLabel)
        view.addSubview(startButton)
        
        setConstraints()
        
        self.view.backgroundColor = UIColor.secondarySystemBackground
        self.navigationItem.title = "Novo Percurso"
        
        updateButtonTitle()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManagerDelegate = LocationManagerDelegate(mapView: mapViewComponent.mapView, viewController: self, speedLabel: speedLabel, routeManager: routeManager)
        locationManager?.delegate = locationManagerDelegate
        
        locationManager?.startUpdatingLocation()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        mapViewComponent.mapView.userTrackingMode = .followWithHeading
        mapViewComponent.mapView.showsUserLocation = true
    }
    
    private func setConstraints() {
        mapViewComponent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapViewComponent.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mapViewComponent.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            mapViewComponent.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapViewComponent.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            speedLabel.widthAnchor.constraint(equalToConstant: 100),
            speedLabel.heightAnchor.constraint(equalToConstant: 100),
            speedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            speedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            
            startButton.topAnchor.constraint(equalTo: mapViewComponent.bottomAnchor, constant: 40),
            startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 118),
            startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -119)
        ])
    }
    
    private func updateButtonTitle() {
        let title = isSaving ? "Finalizar" : "Gravar Rota"
        startButton.setTitle(title, for: .normal)
        
        let color = isSaving ? UIColor.systemRed : UIColor.systemGreen
        startButton.backgroundColor = color
    }
    
    @objc private func toggleSaving() {
        isSaving.toggle()
    }
    
    private func showSaveRouteScreen() {
        let saveRouteVC = SaveRouteViewController()
        saveRouteVC.routes = routes
        saveRouteVC.routePoints = routeManager.routePoints
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
    AddViewController(routes: Routes())
}
