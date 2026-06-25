//
//  PatronesParte1View.swift
//  parcial2-iOS
//
//  Created by Kevin Isai Garcia Parida on 25/06/26.
//

import SwiftUI

extension Notification.Name {
    static let temporizadorFinalizado = Notification.Name("temporizadorFinalizado")
}

protocol Descriptible {
    var titulo: String { get }
    func descripcion() -> String
}

extension Descriptible {
    func descripcion() -> String {
        "Patrón aplicado: \(titulo)"
    }
}

struct PatronDemo: Descriptible {
    let titulo: String
}

struct PatronesParte1View: View {
    @State private var controlador = TemporizadorViewController()
    @State private var mensajeNotificacion = "Esperando evento"

    private let configuracion = ConfiguracionApp.shared
    private let ejemploPOP = PatronDemo(titulo: "Protocol-Oriented Programming")

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Temporizador Delegate")
                    .font(.headline)

                Text("\(controlador.segundos)")
                    .font(.system(size: 64, weight: .bold, design: .monospaced))

                Text(controlador.estado)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 12) {
                Button("Iniciar") {
                    controlador.iniciar()
                }
                .buttonStyle(.borderedProminent)

                Button("Detener") {
                    controlador.detener()
                }
                .buttonStyle(.bordered)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Singleton")
                    .font(.headline)
                Text("Usuario: \(configuracion.nombreUsuario)")
                Text("Modo práctica: \(configuracion.modoPractica ? "Activo" : "Inactivo")")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 10) {
                Text("NotificationCenter + POP")
                    .font(.headline)
                Text(mensajeNotificacion)
                Text(ejemploPOP.descripcion())
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .padding()
        .navigationTitle("Patrones iOS")
        .onReceive(NotificationCenter.default.publisher(for: .temporizadorFinalizado)) { _ in
            mensajeNotificacion = "NotificationCenter recibió: tiempo terminado"
        }
        .onDisappear {
            controlador.detener()
        }
    }
}

@Observable
final class TemporizadorViewController: TemporizadorDelegate {
    private let manager = TemporizadorManager()

    var segundos = 10
    var estado = "Listo para iniciar"

    init() {
        manager.delegate = self
    }

    func iniciar() {
        estado = "Contando"
        manager.iniciar()
    }

    func detener() {
        estado = "Detenido"
        manager.detener()
    }

    func tiempoActualizado(segundos: Int) {
        self.segundos = segundos
    }

    func tiempoTerminado() {
        estado = "Tiempo terminado"
        NotificationCenter.default.post(name: .temporizadorFinalizado, object: nil)
    }
}

#Preview {
    NavigationStack {
        PatronesParte1View()
    }
}
