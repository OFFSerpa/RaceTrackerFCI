//
//  AddViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 15/05/24.
//

import UIKit
import MapKit

class AddViewController: UIViewController, MKMapViewDelegate{
    
    var locationManager: CLLocationManager?
    var locationManagerDelegate: LocationManagerDelegate?
    
    var polylines: [MKPolyline] = []
    
    var routeCoordinates: [CLLocationCoordinate2D] = []
    var currentPolyline: MKPolyline?
    
    var isSaving: Bool = false {
        didSet {
            locationManagerDelegate?.isSaving = isSaving
        }
    }
    
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gravar Rota", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        setMap()
        setStartButton()
        
        self.view.backgroundColor = UIColor.secondarySystemBackground
        self.navigationItem.title = "Novo Percuso"
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        mapView.delegate = self
    }
    
    
    //Func para atualizar o velocimento da tela
    
    public func updateSpeedLabel(speed: CLLocationSpeed) {
        let speedInKmH = speed * 3.6
        speedLabel.text = String(format: "Velocidade: %.2f km/h", speedInKmH)
    }
    
    //Configuração do Mapa
    
    func setMap() {
        view.addSubview(mapView)
        
        
        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
        ])
    }
    
    func setStartButton() {
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            
            startButton.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: 40),
            startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 118),
            startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -119)
            
        ])
    }

    
    public func checkAuthorization() {
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 550, longitudinalMeters: 550)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("Location services has been denied ")
        case .notDetermined, .restricted:
            print("")
        @unknown default:
            print("")
        }
    }
    
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            // Show alert letting the user know what’s up
            break
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
}




extension AddViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}


#Preview {
    AddViewController()
}
