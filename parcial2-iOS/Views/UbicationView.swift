//
//  UbicationView.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import SwiftUI
import CoreLocation

struct UbicacionView: View {
    @State private var locationManager = LocationManager()

    var body: some View {
        VStack(spacing: 16) {
            switch locationManager.estadoPermiso {
            case .notDetermined:
                Button("Solicitar permiso de ubicación") {
                    locationManager.solicitarPermiso()
                }
                .buttonStyle(.borderedProminent)

            case .denied, .restricted:
                VStack(spacing: 8) {
                    Image(systemName: "location.slash")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Text("Permiso denegado.")
                        .bold()
                    Text("Ve a Configuración > Privacidad > Ubicación y actívala para esta app.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding()

            case .authorizedWhenInUse, .authorizedAlways:
                if let error = locationManager.error {
                    Text("Error: \(error)")
                        .foregroundStyle(.red)
                } else if let coord = locationManager.ubicacion {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("GPS activo", systemImage: "location.fill")
                            .foregroundStyle(.green)
                            .font(.headline)

                        Divider()

                        InfoRow(icono: "map", titulo: "Latitud",
                                valor: String(format: "%.6f°", coord.latitude))
                        InfoRow(icono: "map", titulo: "Longitud",
                                valor: String(format: "%.6f°", coord.longitude))

                        if let alt = locationManager.altitud {
                            InfoRow(icono: "mountain.2", titulo: "Altitud",
                                    valor: String(format: "%.1f m", alt))
                        }
                        if let vel = locationManager.velocidad {
                            InfoRow(icono: "speedometer", titulo: "Velocidad",
                                    valor: String(format: "%.1f m/s", vel))
                        }
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .padding()
                } else {
                    ProgressView("Obteniendo ubicación…")
                }

            default:
                EmptyView()
            }
        }
        .navigationTitle("Ubicación GPS")
        .onAppear { locationManager.solicitarPermiso() }
    }
}

private struct InfoRow: View {
    let icono: String
    let titulo: String
    let valor: String

    var body: some View {
        HStack {
            Label(titulo, systemImage: icono)
                .foregroundStyle(.secondary)
            Spacer()
            Text(valor)
                .bold()
                .font(.system(.body, design: .monospaced))
        }
    }
}

#Preview {
    NavigationStack {
        UbicacionView()
    }
}
