//
//  CardViewUI.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 28/10/24.
//

import SwiftUI

var routeName: String = "Velocita"
var distanceLabel: String = "0.00 km/h"

struct CardViewUI: View {
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 350, height: 120)
                .foregroundStyle(Color(.coolWhite))
            
                HStack {
                    
                    Rectangle()
                        .frame(width: 80, height: 80)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(routeName)
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        Text(distanceLabel)
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 35)
                    .padding(.trailing, 20)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                    
                    
                }
            } .frame(width: 350, height: 120)
    }
}

#Preview {
    CardViewUI()
}
