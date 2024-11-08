//
//  SpeedLabelUI .swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 28/10/24.
//

import SwiftUI
import CoreLocation


struct SpeedLabelUI_: View {
    
     var speedInKmH: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.white)
                .overlay {
                    Circle()
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 6))
                }
            VStack {
                Text(speedInKmH)
                    .font(.system(size: 28))
                    .bold()
                Text("km/h")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 14))

            }
        }.frame(height: 100)
    }
}

