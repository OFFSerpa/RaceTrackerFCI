//
//  RaceSummaryViewController .swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 26/04/25.
//

import UIKit
import MapKit

class RaceSummaryViewController: UIViewController {
    
    var route: Route?
    var elapsedTime: TimeInterval?
    var lapCount: Int = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Resumo da Corrida"
        label.font = UIFont.italicSystemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0 min"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bestTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "10 min"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.dynamic(light: .black, dark: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lapCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 voltas"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.dynamic(light: .black, dark: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupUI()
        displayRaceSummary()
    }
    
    private func setupUI() {
        [titleLabel, mapView, timeLabel, bestTimeLabel, lapCountLabel].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mapView.heightAnchor.constraint(equalToConstant: 300),
            
            timeLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bestTimeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            bestTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lapCountLabel.topAnchor.constraint(equalTo: bestTimeLabel.bottomAnchor, constant: 10),
            lapCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func displayRaceSummary() {
        guard let route = route, let elapsedTime = elapsedTime else { return }
        
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let timeString = String(format: "%d:%02d", minutes, seconds)
        timeLabel.text = "Tempo: \(timeString)"
        
        let bestTime = route.bestTime
        bestTimeLabel.text = "Melhor Tempo: \(bestTime)"
        
        lapCountLabel.text = "Voltas: \(lapCount)"
        
        if let bestTimeInterval = route.bestTimeInterval, elapsedTime < bestTimeInterval {
            route.bestTime = timeString
        }
        
        let coordinates = route.points.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        var regionRect = polyline.boundingMapRect
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        mapView.setVisibleMapRect(regionRect, animated: true)
        
        mapView.delegate = self
    }
}

#Preview {
    RaceSummaryViewController()
}
