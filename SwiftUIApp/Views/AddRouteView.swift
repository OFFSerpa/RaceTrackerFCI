//
//  AddRouteView.swift
//  TimeChamps
//
//  Created by Vinicius Serpa on 29/10/24.
//


import SwiftUI
import MapKit

struct AddRouteView: View {
    @ObservedObject var viewModel: AddRouteViewModel

    var body: some View {
        VStack {
            // Mapa
            MapViewUI(routePoints: viewModel.routePoints)
                .edgesIgnoringSafeArea(.top)
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .onAppear {
                    // Configurar o mapView, se necessário
                }

            // Speed Label
            SpeedLabelUI_(speedInKmH: String(format: "%.0f", viewModel.currentSpeed * 3.6))
                .offset(x: UIScreen.main.bounds.width / 2 - 70, y: -80) // Ajuste de posição

            // Botão de Iniciar/Parar
            Button(action: {
                viewModel.toggleSaving()
            }) {
                Text(viewModel.isSaving ? "Finalizar" : "Gravar Rota")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(viewModel.isSaving ? Color.red : Color.green)
                    .cornerRadius(25)
            }
            .padding(.top, -50)

            Spacer()
        }
        .navigationTitle("Novo Percurso")
        .background(Color(UIColor.secondarySystemBackground))
    }
}
