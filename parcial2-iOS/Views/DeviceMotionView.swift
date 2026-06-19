
//
//  DeviceMotionView.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

//
//  DeviceMotionView.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import SwiftUI

struct DeviceMotionView: View {
    @State private var deviceMotion = DeviceMotionManager()
    @State private var detector     = DetectorCaidaManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: Orientación
                SensorCardDM(titulo: "Orientación", icono: "rotate.3d") {
                    DMRow(etiqueta: "Pitch", valor: deviceMotion.pitch, color: .orange, sufijo: "°")
                    DMRow(etiqueta: "Roll",  valor: deviceMotion.roll,  color: .purple, sufijo: "°")
                    DMRow(etiqueta: "Yaw",   valor: deviceMotion.yaw,   color: .teal,   sufijo: "°")
                }

                // MARK: Aceleración del usuario (sin gravedad)
                SensorCardDM(titulo: "Aceleración usuario (sin gravedad)", icono: "arrow.up.and.down.and.left.and.right") {
                    DMRow(etiqueta: "X", valor: deviceMotion.aceleracionX, color: .red)
                    DMRow(etiqueta: "Y", valor: deviceMotion.aceleracionY, color: .green)
                    DMRow(etiqueta: "Z", valor: deviceMotion.aceleracionZ, color: .blue)
                }

                // MARK: Detector de caída
                SensorCardDM(titulo: "Detector de caída", icono: "exclamationmark.triangle") {
                    HStack {
                        Text("Estado")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(detector.alertaCaida ? "¡CAÍDA DETECTADA!" : "Normal")
                            .bold()
                            .foregroundStyle(detector.alertaCaida ? .red : .green)
                    }
                    if detector.alertaCaida {
                        Button("Reiniciar alerta") { detector.reiniciarAlerta() }
                            .buttonStyle(.bordered)
                            .tint(.red)
                    }
                }

            }
            .padding()
        }
        .navigationTitle("Device Motion")
        .onAppear {
            deviceMotion.iniciar()
            detector.iniciar()
        }
        .onDisappear {
            deviceMotion.detener()
            detector.detener()
        }
        .alert("¡Caída detectada!", isPresented: $detector.alertaCaida) {
            Button("OK") { detector.reiniciarAlerta() }
        } message: {
            Text("Se detectó un impacto brusco.")
        }
    }
}

// MARK: - Subviews locales

private struct SensorCardDM<Content: View>: View {
    let titulo: String
    let icono: String
    @ViewBuilder let contenido: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(titulo, systemImage: icono)
                .font(.headline)
            Divider()
            contenido
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct DMRow: View {
    let etiqueta: String
    let valor: Double
    let color: Color
    var sufijo: String = ""

    var body: some View {
        HStack {
            Text(etiqueta)
                .foregroundStyle(color)
                .bold()
                .frame(width: 60, alignment: .leading)
            Spacer()
            Text(String(format: "%.3f\(sufijo)", valor))
                .font(.system(.body, design: .monospaced))
        }
    }
}

#Preview {
    NavigationStack {
        DeviceMotionView()
    }
}
