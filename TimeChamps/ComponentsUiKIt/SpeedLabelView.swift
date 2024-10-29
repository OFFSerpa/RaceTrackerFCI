//
//  SpeedLabelView.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 21/05/24.
//

import Foundation
import CoreLocation
import UIKit

class SpeedLabelView: UIView {
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let unitLabel: UILabel = {
        let label = UILabel()
        label.text = "km/h"
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 50
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        
        addSubview(speedLabel)
        addSubview(unitLabel)
        
        NSLayoutConstraint.activate([
            speedLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            speedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8),
            
            unitLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            unitLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 0),
            
            self.widthAnchor.constraint(equalToConstant: 100),
            self.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    public func updateSpeed(speed: CLLocationSpeed) {
        let speedInKmH = speed * 3.6
        speedLabel.text = String(format: "%.0f", speedInKmH)
    }
}
