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
    let routes = Routes() // Adiciona a instância de Routes para gerenciar as rotas
    
    var isSaving: Bool = false {
        didSet {
            locationManagerDelegate?.isSaving = isSaving
            updateButtonTitle()
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
        if isSaving {
            let alertController = UIAlertController(title: "Nome da Rota", message: "Digite um nome para a rota", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "Nome"
            }
            let saveAction = UIAlertAction(title: "Salvar", style: .default) { [weak self] _ in
                guard let routeName = alertController.textFields?.first?.text, !routeName.isEmpty else { return }
                self?.saveCurrentRoute(name: routeName)
            }
            alertController.addAction(saveAction)
            alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            present(alertController, animated: true)
        } else {
            startNewRoute()
        }
        isSaving.toggle()
    }
    
    private func startNewRoute() {
        routeCoordinates = []
        currentPolyline = nil
    }
    
    private func saveCurrentRoute(name: String) {
        routes.addRoute(name: name, coordinates: routeCoordinates)
        routeCoordinates = []
        currentPolyline = nil
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
}

#Preview {
    AddViewController()
}
