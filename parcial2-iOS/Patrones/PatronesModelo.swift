//
//  PatronesModelo.swift
//  parcial2-iOS
//
//  Sesiones 11 y 12 (25/06/2026 - 26/06/2026) · Patrones de diseño en iOS.
//  Implementaciones puras de cada patrón, separadas de la capa de UI.
//  Created by Alberto Lopez on 26/06/26.
//

import Foundation
import Observation

// MARK: - 1. Singleton (Sesión 11)
// Una sola instancia compartida vía `static let shared`. Equivalente al `object` de Kotlin.

final class ConfiguracionApp {
    static let shared = ConfiguracionApp()
    private init() {}

    var nombreUsuario: String = "Invitado"
    var modoOscuro: Bool = false
}

// MARK: - 2. Delegate Pattern (Sesión 11)
// Un objeto delega una responsabilidad a otro vía un `protocol`. El patrón más "iOS".

protocol DescargaDelegate: AnyObject {   // AnyObject permite declarar el delegado como weak
    func descargaCompletada(archivo: String)
    func descargaFallo(error: String)
    func progresoActualizado(porcentaje: Double)
}

extension DescargaDelegate {
    // Implementación por defecto: adoptar el protocolo no obliga a implementar este método.
    func progresoActualizado(porcentaje: Double) {}
}

final class DescargaManager {
    weak var delegate: DescargaDelegate?   // weak evita el retain cycle

    func iniciarDescarga(url: String) {
        for i in stride(from: 0, through: 100, by: 25) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) / 50) { [weak self] in
                self?.delegate?.progresoActualizado(porcentaje: Double(i))
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) { [weak self] in
            guard let self else { return }
            if url.hasPrefix("https") {
                self.delegate?.descargaCompletada(archivo: "documento.pdf")
            } else {
                self.delegate?.descargaFallo(error: "URL insegura")
            }
        }
    }
}

// MARK: - 3. Observer / NotificationCenter (Sesión 11)
// Publish-subscribe nativo, anterior a Combine. Equivalente a LiveData/BroadcastReceiver.

extension Notification.Name {
    static let usuarioCambiado    = Notification.Name("usuarioCambiado")
    static let carritoActualizado = Notification.Name("carritoActualizado")
}

struct CarritoEvento {
    let totalItems: Int
    let montoTotal: Double
}

final class SesionManager {
    func cerrarSesion() {
        NotificationCenter.default.post(
            name: .usuarioCambiado, object: nil, userInfo: ["accion": "logout"]
        )
    }

    func notificarCarrito(items: Int, monto: Double) {
        let evento = CarritoEvento(totalItems: items, montoTotal: monto)
        NotificationCenter.default.post(name: .carritoActualizado, object: evento)
    }
}

// MARK: - 4. Protocol-Oriented Programming (Sesión 11)
// Swift favorece protocolos + extensiones sobre herencia.

protocol Saludable {
    var nombre: String { get }
    func saludar() -> String
}

extension Saludable {
    func saludar() -> String { "Hola, soy \(nombre)" }   // default
}

protocol ConIdentificador {
    var id: String { get }
}

// Tipo que cumple AMBOS contratos
struct Estudiante: Saludable, ConIdentificador {
    var nombre: String
    var id: String
}

struct ProfesorPOP: Saludable {
    var nombre: String
    func saludar() -> String { "Buenos días, profesor \(nombre)" }   // sobrescribe el default
}

// Función genérica: acepta CUALQUIER tipo que cumpla Saludable
func presentar<T: Saludable>(_ persona: T) -> String {
    persona.saludar()
}

// MARK: - 5. MVVM + Repository + Dependency Injection (Sesión 12)
// View (SwiftUI) <-> ViewModel (@Observable) <-> Model (datos puros).

struct Producto: Identifiable, Codable, Hashable {
    let id: Int
    let nombre: String
    let precio: Double
}

protocol ProductoRepository {
    func obtenerProductos() async throws -> [Producto]
}

final class ProductoRepositoryImpl: ProductoRepository {
    func obtenerProductos() async throws -> [Producto] {
        try await Task.sleep(for: .milliseconds(500))   // simula latencia de red
        return [
            Producto(id: 1, nombre: "Laptop", precio: 15999),
            Producto(id: 2, nombre: "Mouse",  precio: 399)
        ]
    }
}

final class ProductoRepositoryMock: ProductoRepository {
    var productosAEntregar: [Producto] = [Producto(id: 99, nombre: "Producto de prueba", precio: 1)]
    var deberiaFallar = false

    func obtenerProductos() async throws -> [Producto] {
        if deberiaFallar {
            throw NSError(domain: "Mock", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Error simulado"])
        }
        return productosAEntregar
    }
}

@MainActor
@Observable
class ProductosViewModel {
    var productos: [Producto] = []
    var cargando = false
    var error: String?

    private let repository: ProductoRepository

    // Dependency Injection por inicializador: facilita inyectar un Mock en tests.
    init(repository: ProductoRepository) {
        self.repository = repository
    }

    func cargarProductos() async {
        cargando = true
        error = nil
        do {
            productos = try await repository.obtenerProductos()
        } catch {
            self.error = error.localizedDescription
        }
        cargando = false
    }

    var totalInventario: Double {
        productos.reduce(0) { $0 + $1.precio }
    }
}

// MARK: - 6. Coordinator Pattern (Sesión 12)
// Saca la lógica de navegación fuera de las Views.

enum Pantalla: Hashable {
    case detalle(Producto)
    case configuracion
}

enum PantallaModal: Identifiable {
    case agregarProducto
    case filtros
    var id: Int { hashValue }
}

@MainActor
@Observable
class AppCoordinator {
    var ruta: [Pantalla] = []
    var modalActivo: PantallaModal?

    func irADetalle(_ producto: Producto) { ruta.append(.detalle(producto)) }
    func irAConfiguracion()               { ruta.append(.configuracion) }
    func mostrarModalAgregar()            { modalActivo = .agregarProducto }
    func cerrarModal()                    { modalActivo = nil }
    func regresarAInicio()                { ruta.removeAll() }
}
