//
//  ViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 25/04/25.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    var isDark: Bool = true
    var isFirst: Bool = true
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Trajetos"
        titleLabel.font = UIFont.italicSystemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: "plus.circle", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    let routeRepository = RouteRepository()
    var tableViewDelegate: TableViewDelegate?

        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.backgroundColor = UIColor.dynamic(light: .coolBlue, dark: .backBlack)

            setElements()
            configureTableView()

            loadMockRoutesFromGeoJSON()

            NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
        func loadMockRoutesFromGeoJSON() {
            guard let url = Bundle.main.url(forResource: "mock_routes", withExtension: "geojson"),
                  let data = try? Data(contentsOf: url) else {
                print("❌ Erro ao localizar ou ler o mock_routes.geojson")
                return
            }

            do {
                let decoder = MKGeoJSONDecoder()
                let objects = try decoder.decode(data)
                let features = objects.compactMap { $0 as? MKGeoJSONFeature }
                routeRepository.addGeoJSONFeatures(features)
                tableView.reloadData()
                print("✅ Rotas mock carregadas: \(features.count)")
            } catch {
                print("❌ Erro ao decodificar GeoJSON: \(error)")
            }
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSafetyAlert()
    }

    func setElements() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        setConstraints()
        setAddButton()
    }
    
    func setAddButton() {
        view.addSubview(addButton)
        self.addButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)
        
        let color = isDark ? UIColor.white : UIColor.black
        addButton.tintColor = color
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            addButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])
    }
    
    @objc func navigate() {
        let destination = AddViewController(routes: routeRepository)
        navigationController?.pushViewController(destination, animated: true)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    func configureTableView() {
        tableViewDelegate = TableViewDelegate(routes: routeRepository, navigationController: navigationController)
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: "RouteCell")
    }

    @objc func updateTableView() {
        tableView.reloadData()
    }

    private func showSafetyAlert() {
        if isFirst {
            let alertController = UIAlertController(title: "Aplicativo Destinado a Profissionais", message: "Este app é destinado para uso apenas profissional em um ambiente seguro e controlado, sendo totalmente preparado para corrida, sempre dirija de maneira segura! Não use o celular ao volante.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true, completion: nil)
            isFirst = false
        }
    }
}
