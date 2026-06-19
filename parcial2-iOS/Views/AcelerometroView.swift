//
//  AcelerometroView.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import SwiftUI

struct AcelerometroView: View {
    @State private var acelerometro = AcelerometroManager()
    @State private var giroscopio   = GiroscopioManager()
    @State private var deviceMotion = DeviceMotionManager()
    @State private var detector     = DetectorCaidaManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: Acelerómetro crudo
                SensorCard(titulo: "Acelerómetro", icono: "move.3d") {
                    EjeRow(eje: "X", valor: acelerometro.x, color: .red)
                    EjeRow(eje: "Y", valor: acelerometro.y, color: .green)
                    EjeRow(eje: "Z", valor: acelerometro.z, color: .blue)
                }

                // MARK: Giroscopio
                SensorCard(titulo: "Giroscopio (rad/s)", icono: "gyroscope") {
                    EjeRow(eje: "X", valor: giroscopio.rotacionX, color: .red)
                    EjeRow(eje: "Y", valor: giroscopio.rotacionY, color: .green)
                    EjeRow(eje: "Z", valor: giroscopio.rotacionZ, color: .blue)
                }

                // MARK: Device Motion (fusionado)
                SensorCard(titulo: "Orientación (Device Motion)", icono: "rotate.3d") {
                    EjeRow(eje: "Pitch", valor: deviceMotion.pitch, color: .orange, sufijo: "°")
                    EjeRow(eje: "Roll",  valor: deviceMotion.roll,  color: .purple, sufijo: "°")
                    EjeRow(eje: "Yaw",   valor: deviceMotion.yaw,   color: .teal,   sufijo: "°")
                    Divider()
                    EjeRow(eje: "aX", valor: deviceMotion.aceleracionX, color: .red)
                    EjeRow(eje: "aY", valor: deviceMotion.aceleracionY, color: .green)
                    EjeRow(eje: "aZ", valor: deviceMotion.aceleracionZ, color: .blue)
                }

                // MARK: Detector de caída
                SensorCard(titulo: "Detector de caída", icono: "exclamationmark.triangle") {
                    HStack {
                        Text("Estado")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(detector.alertaCaida ? "¡CAÍDA DETECTADA!" : "Normal")
                            .bold()
                            .foregroundStyle(detector.alertaCaida ? .red : .green)
                    }
                    if detector.alertaCaida {
                        Button("Reiniciar alerta") {
                            detector.reiniciarAlerta()
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }

            }
            .padding()
        }
        .navigationTitle("Sensores")
        .onAppear {
            acelerometro.iniciar()
            giroscopio.iniciar()
            deviceMotion.iniciar()
            detector.iniciar()
        }
        .onDisappear {
            acelerometro.detener()
            giroscopio.detener()
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

// MARK: - Subviews reutilizables

private struct SensorCard<Content: View>: View {
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

private struct EjeRow: View {
    let eje: String
    let valor: Double
    let color: Color
    var sufijo: String = ""

    var body: some View {
        HStack {
            Text(eje)
                .foregroundStyle(color)
                .bold()
                .frame(width: 50, alignment: .leading)
            Spacer()
            Text(String(format: "%.3f\(sufijo)", valor))
                .font(.system(.body, design: .monospaced))
        }
    }
}

#Preview {
    NavigationStack {
        AcelerometroView()
    }
}
