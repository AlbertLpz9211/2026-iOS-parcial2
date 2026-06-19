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
                Label("GPS", systemImage: "location.fill")
            }

            NavigationStack {
                AcelerometroView()
            }
            .tabItem {
                Label("Sensores", systemImage: "gyroscope")
            }
        }
    }
}

#Preview {
    ContentView()
}
