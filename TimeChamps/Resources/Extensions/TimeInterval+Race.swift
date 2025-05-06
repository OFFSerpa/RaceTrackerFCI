//
//  TimeStamp+map.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 05/05/25.
//

import Foundation

extension TimeInterval {
    var formattedTime: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
