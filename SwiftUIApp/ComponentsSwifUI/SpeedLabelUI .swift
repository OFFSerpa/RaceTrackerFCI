//
//  SpeedLabelUI .swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 28/10/24.
//

import SwiftUI
import CoreLocation


struct SpeedLabelUI_: View {
    
    @State private var speedInKmH: String = "0"
    
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
    
    func updateSpeed(speed: CLLocationSpeed) {
         let speedInKmH = speed * 3.6
         self.speedInKmH = String(format: "%.0f", speedInKmH)
     }
}

#Preview {
    SpeedLabelUI_()
}
