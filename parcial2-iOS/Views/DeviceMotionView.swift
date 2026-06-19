//
//  DeviceMotionView.swift
//  parcial2-iOS
//
//  Created by Kevin Isai Garcia Parida on 19/06/26.
//

import SwiftUI

struct DeviceMotionView: View {
    @State private var deviceMotionManager = DeviceMotionManager()

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gyroscope")
                .font(.system(size: 56))
                .foregroundStyle(.blue)

            VStack(spacing: 12) {
                MotionRow(title: "Pitch", value: deviceMotionManager.pitch, suffix: "°")
                MotionRow(title: "Roll", value: deviceMotionManager.roll, suffix: "°")
                MotionRow(title: "Yaw", value: deviceMotionManager.yaw, suffix: "°")
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .padding()
        .navigationTitle("Device Motion")
        .onAppear {
            deviceMotionManager.iniciar()
        }
        .onDisappear {
            deviceMotionManager.detener()
        }
    }
}

private struct MotionRow: View {
    let title: String
    let value: Double
    let suffix: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(String(format: "%.3f%@", value, suffix))
                .font(.system(.title3, design: .monospaced))
                .bold()
        }
    }
}
#Preview {
    NavigationStack {
        DeviceMotionView()
    }
}

