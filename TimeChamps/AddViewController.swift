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
    
    let startButton: UIButton = {
        let button = UIButton()
     
        button.setTitle("Gravar Rota", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()

        
        setElements()
        self.view.backgroundColor = UIColor.secondarySystemBackground
        self.navigationItem.title = "Novo Percuso"
        
        
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        mapView.delegate = self
        
        
        
    }
    
    func setElements() {
        setMap()
        setStartButton()
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
