//
//  ViewController.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 15/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    var isDark: Bool = true
    
    
 
    
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
    
    let routes = Routes()
    var tableViewDelegate: TableViewDelegate?
    
    override func viewDidLoad() {
        
        if self.traitCollection.userInterfaceStyle == .light{
            isDark = false
        }
        
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
        
        let color = isDark ? UIColor.white : UIColor.black
        addButton.tintColor = color
        
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
        tableViewDelegate = TableViewDelegate(routes: routes, navigationController: navigationController)
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: "RouteCell")
    }
    
    @objc func navigate() {
        let destination = AddViewController(routes: routes)
        navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func updateTableView() {
        tableView.reloadData()
        
    }
}

#Preview {
    ViewController()
}
