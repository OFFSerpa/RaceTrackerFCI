//
//  RouteTableViewCell.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mapViewComponent: MapViewComponent = {
        let mapView = MapViewComponent()
        mapView.layer.cornerRadius = 10
        mapView.clipsToBounds = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectedBackgroundView = UIView()

        contentView.addSubview(cardView)
        cardView.addSubview(mapViewComponent)
        cardView.addSubview(titleLabel)
        cardView.addSubview(distanceLabel)
        cardView.addSubview(bestTimeLabel)
        cardView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            mapViewComponent.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            mapViewComponent.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            mapViewComponent.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            mapViewComponent.widthAnchor.constraint(equalTo: mapViewComponent.heightAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: mapViewComponent.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            
            distanceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            bestTimeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bestTimeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5),
            bestTimeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            
            arrowImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            arrowImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with route: Route) {
        titleLabel.text = route.name
        distanceLabel.text = "\(String(format: "%.2f", route.distance)) km"
        bestTimeLabel.text = "Melhor Tempo: \(route.bestTime)"
        
        mapViewComponent.routePoints = route.points
        mapViewComponent.showRouteOnMap()
    }
}
