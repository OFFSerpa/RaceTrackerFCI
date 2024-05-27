//
//  SaveRouteViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//


import UIKit
import CoreLocation
import MapKit

class SaveRouteViewController: UIViewController {

    var routes: Routes?
    var routePoints: [RoutePoint] = []
    var onSave: (() -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Novo Percurso"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite o nome da rota"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distância: 0 km"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Tempo: 0 min"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let mapViewComponent: MapViewComponent = {
        let mapView = MapViewComponent()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveRoute), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Excluir", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteRoute), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.secondarySystemBackground
        setupUI()
        configureMap()
        
        nameTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(distanceLabel)
        view.addSubview(timeLabel)
        view.addSubview(mapViewComponent)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            distanceLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            distanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            distanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            mapViewComponent.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            mapViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mapViewComponent.heightAnchor.constraint(equalToConstant: 400),
            
            saveButton.topAnchor.constraint(equalTo: mapViewComponent.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            deleteButton.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureMap() {
        mapViewComponent.routePoints = routePoints
        
        if let routes = routes {
            let distance = routes.calculateDistance(points: routePoints)
            distanceLabel.text = String(format: "Distância: %.2f km", distance)
            timeLabel.text = "Tempo: \(routes.calculateBestTime(points: routePoints))"
        }
        
        adjustMapZoom()
    }
    
    private func adjustMapZoom() {
        let coordinates = routePoints.map { $0.coordinate }
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
    
    @objc private func saveRoute() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        routes?.addRoute(name: name, points: routePoints)
        onSave?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteRoute() {
        mapViewComponent.mapView.removeOverlays(mapViewComponent.mapView.overlays)
        routePoints.removeAll()
        distanceLabel.text = "Distância: 0 km"
        timeLabel.text = "Tempo: 0 min"
        dismiss(animated: true, completion: nil)
    }
}

extension SaveRouteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

#Preview {
    SaveRouteViewController()
}
