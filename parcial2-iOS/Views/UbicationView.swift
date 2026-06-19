//
//  UbicationView.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import CoreLocation
import SwiftUI

struct UbicacionView: View {
    @State private var locationManager = LocationManager()

    var body: some View {
        VStack(spacing: 20) {
            switch locationManager.estadoPermiso {
            case .notDetermined:
                PermissionRequestView {
                    locationManager.solicitarPermiso()
                }

            case .authorizedWhenInUse, .authorizedAlways:
                AuthorizedLocationView(
                    coordinate: locationManager.ubicacion,
                    error: locationManager.error
                )

            case .denied, .restricted:
                LocationDeniedView()

            @unknown default:
                Text("Estado de permiso desconocido.")
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Ubicación")
        .onAppear {
            locationManager.solicitarPermiso()
        }
        .onDisappear {
            locationManager.detenerActualizaciones()
        }
    }
}

private struct PermissionRequestView: View {
    let requestPermission: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.circle")
                .font(.system(size: 56))
                .foregroundStyle(.blue)

            Text("Permiso pendiente")
                .font(.headline)

            Button("Solicitar ubicación") {
                requestPermission()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct AuthorizedLocationView: View {
    let coordinate: CLLocationCoordinate2D?
    let error: String?

    var body: some View {
        VStack(spacing: 12) {
            Label("GPS activo", systemImage: "location.fill")
                .font(.headline)
                .foregroundStyle(.green)

            if let error {
                Text(error)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            } else if let coordinate {
                VStack(spacing: 12) {
                    LocationRow(title: "Latitud", value: String(format: "%.6f", coordinate.latitude))
                    LocationRow(title: "Longitud", value: String(format: "%.6f", coordinate.longitude))
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            } else {
                ProgressView("Obteniendo ubicación")
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct LocationDeniedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.slash")
                .font(.system(size: 56))
                .foregroundStyle(.red)

            Text("Permiso no disponible")
                .font(.headline)

            Text("Activa la ubicación para esta app desde Configuración > Privacidad y seguridad > Ubicación.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct LocationRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(.title3, design: .monospaced))
                .bold()
        }
    }
}

#Preview {
    NavigationStack {
        UbicacionView()
    }
}
