//
//  ViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 15/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Trajetos"
        titleLabel.font = UIFont.italicSystemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .white
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
    
    let routes = Routes() // Instância de Routes para gerenciar as rotas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondarySystemBackground
        
        setElements()
        configureTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableView()
    }
    
    func setElements() {
        setTitle()
        setAddButton()
        setTableView()
    }
    
    func setAddButton() {
        view.addSubview(addButton)
        self.addButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            addButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5)
        ])
    }
    
    func setTitle() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    func setTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: "RouteCell")
    }
    
    @objc func navigate() {
        let destination = AddViewController(routes: routes) // Passa a instância de Routes para a AddViewController
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func updateTableView() {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.allRoutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteTableViewCell
        let route = routes.allRoutes[indexPath.row]
        cell.configure(with: route)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UIFont {
    class func italicSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        switch weight {
        case .ultraLight, .light, .thin, .regular:
            return font.withTraits(.traitItalic, ofSize: size)
        case .medium, .semibold, .bold, .heavy, .black:
            return font.withTraits(.traitBold, .traitItalic, ofSize: size)
        default:
            return UIFont.italicSystemFont(ofSize: size)
        }
    }
    
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits..., ofSize size: CGFloat) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: size)
    }
}

#Preview {
    ViewController()
}
