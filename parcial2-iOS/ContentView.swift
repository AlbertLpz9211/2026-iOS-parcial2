//
//  ContentView.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 17/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                UbicacionView()
            }
            .tabItem {
                Label("Ubicación", systemImage: "location.fill")
            }

            NavigationStack {
                AcelerometroView()
            }
            .tabItem {
                Label("Acelerómetro", systemImage: "move.3d")
            }

            NavigationStack {
                DeviceMotionView()
            }
            .tabItem {
                Label("Device Motion", systemImage: "gyroscope")
            }

            NavigationStack {
                PatronesParte1View()
            }
            .tabItem {
                Label("Patrones", systemImage: "timer")
            }
        }
    }
}

#Preview {
    ContentView()
}
