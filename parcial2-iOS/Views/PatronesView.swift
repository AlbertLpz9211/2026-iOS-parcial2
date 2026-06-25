//
//  PatronesView.swift
//  parcial2-iOS
//
//  Created by iMac 10 on 25/06/26.
//

import SwiftUI
import Combine

// POP
protocol Saludable {
    var nombre: String { get }
    func saludar() -> String
}

extension Saludable {
    func saludar() -> String {
        "Hola, soy \(nombre)"
    }
}

struct Estudiante: Saludable {
    let nombre: String
}

struct Profesor: Saludable {
    let nombre: String
    
    func saludar() -> String {
        "Buenos días, profesor \(nombre)"
    }
}

// Singleton
final class ConfiguracionApp {
    static let shared = ConfiguracionApp()
    
    let nombreApp = "Patrones iOS"
    let duracionTemporizador = 10
    
    private init() {}
}

// Delegate
protocol TemporizadorDelegate: AnyObject {
    func tiempoActualizado(segundos: Int)
    func tiempoTerminado()
}

final class TemporizadorManager {
    weak var delegate: TemporizadorDelegate?
    private var timer: Timer?
    private var segundosRestantes = ConfiguracionApp.shared.duracionTemporizador
    
    func iniciar() {
        detener()
        segundosRestantes = ConfiguracionApp.shared.duracionTemporizador
        delegate?.tiempoActualizado(segundos: segundosRestantes)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            self.segundosRestantes -= 1
            self.delegate?.tiempoActualizado(segundos: self.segundosRestantes)
            
            if self.segundosRestantes == 0 {
                timer.invalidate()
                self.timer = nil
                self.delegate?.tiempoTerminado()
            }
        }
    }
    
    func detener() {
        timer?.invalidate()
        timer = nil
    }
}

// MVC sencillo: este sería el modelo
struct MensajeModelo {
    let titulo: String
    let descripcion: String
}

// Observer + controlador/vista modelo simple
final class PatronesSesion11ViewModel: ObservableObject, TemporizadorDelegate {
    @Published var segundos = ConfiguracionApp.shared.duracionTemporizador
    @Published var mensaje = "Presiona iniciar"
    @Published var notificacion = "Sin notificaciones"
    
    let modelo = MensajeModelo(
        titulo: "Ejemplos de patrones",
        descripcion: "MVC, Delegate, Singleton, Observer y POP"
    )
    
    let estudiante = Estudiante(nombre: "Eduardo")
    let profesor = Profesor(nombre: "Alberto")
    
    private let temporizador = TemporizadorManager()
    
    init() {
        temporizador.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(recibirNotificacion),
            name: Notification.Name("TemporizadorTerminado"),
            object: nil
        )
    }
    
    func iniciarTemporizador() {
        mensaje = "Temporizador activo"
        temporizador.iniciar()
    }
    
    func tiempoActualizado(segundos: Int) {
        self.segundos = segundos
    }
    
    func tiempoTerminado() {
        mensaje = "Tiempo terminado"
        
        NotificationCenter.default.post(
            name: Notification.Name("TemporizadorTerminado"),
            object: nil
        )
    }
    
    @objc private func recibirNotificacion() {
        notificacion = "Observer recibió la notificación del temporizador"
    }
}

struct PatronesSesion11View: View {
    @StateObject private var viewModel = PatronesSesion11ViewModel()
    private let configuracion = ConfiguracionApp.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                
                Text(configuracion.nombreApp)
                    .font(.largeTitle)
                    .bold()
                
                Text(viewModel.modelo.titulo)
                    .font(.title2)
                    .bold()
                
                Text(viewModel.modelo.descripcion)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                GroupBox("Delegate + Timer") {
                    VStack(spacing: 10) {
                        Text("\(viewModel.segundos)")
                            .font(.system(size: 60, weight: .bold))
                        
                        Text(viewModel.mensaje)
                        
                        Button("Iniciar temporizador") {
                            viewModel.iniciarTemporizador()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                GroupBox("Singleton") {
                    VStack(alignment: .leading) {
                        Text("Nombre app: \(configuracion.nombreApp)")
                        Text("Duración: \(configuracion.duracionTemporizador) segundos")
                    }
                }
                
                GroupBox("Observer") {
                    Text(viewModel.notificacion)
                }
                
                GroupBox("POP") {
                    VStack(alignment: .leading) {
                        Text(viewModel.estudiante.saludar())
                        Text(viewModel.profesor.saludar())
                    }
                }
                
                GroupBox("MVC") {
                    Text("Se usa un modelo simple llamado MensajeModelo para separar datos de la vista.")
                }
            }
            .padding()
        }
    }
}

#Preview {
    PatronesSesion11View()
}
