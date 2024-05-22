//
//  SaveRouteViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//

import UIKit
import CoreLocation

class SaveRouteViewController: UIViewController {
    
    var routes: Routes?
    var routeCoordinates: [CLLocationCoordinate2D] = []
    var onSave: (() -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome da Rota"
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
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveRoute), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.secondarySystemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func saveRoute() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        routes?.addRoute(name: name, coordinates: routeCoordinates)
        onSave?()
        dismiss(animated: true, completion: nil)
    }
}
