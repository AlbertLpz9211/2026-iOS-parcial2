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
