//
//  AcelerometroView.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import SwiftUI

struct AcelerometroView: View {
    @State private var acelerometroManager = AcelerometroManager()

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "move.3d")
                .font(.system(size: 56))
                .foregroundStyle(.orange)

            VStack(spacing: 12) {
                AccelerationRow(axis: "X", value: acelerometroManager.x, color: .red)
                AccelerationRow(axis: "Y", value: acelerometroManager.y, color: .green)
                AccelerationRow(axis: "Z", value: acelerometroManager.z, color: .blue)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .padding()
        .navigationTitle("Acelerómetro")
        .onAppear {
            acelerometroManager.iniciar()
        }
        .onDisappear {
            acelerometroManager.detener()
        }
    }
}

private struct AccelerationRow: View {
    let axis: String
    let value: Double
    let color: Color

    var body: some View {
        HStack {
            Text(axis)
                .bold()
                .foregroundStyle(color)
                .frame(width: 32, alignment: .leading)
            Spacer()
            Text(String(format: "%.3f", value))
                .font(.system(.title3, design: .monospaced))
                .bold()
        }
    }
}

#Preview {
    NavigationStack {
        AcelerometroView()
    }
}
