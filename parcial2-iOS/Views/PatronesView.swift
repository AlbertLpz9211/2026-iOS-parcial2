//
//  PatronesView.swift
//  parcial2-iOS
//
//  Sesiones 11 y 12 (25/06/2026 en adelante) · Visualizador de los patrones
//  de diseño más comunes en iOS. Cada patrón es interactivo y demostrable
//  en el Simulador.
//  Created by Alberto Lopez on 26/06/26.
//

import SwiftUI

// MARK: - Catálogo de patrones

private struct Patron: Identifiable {
    let id = UUID()
    let nombre: String
    let resumen: String
    let icono: String
    let color: Color
    let sesion: String
}

private let catalogoPatrones: [Patron] = [
    Patron(nombre: "Singleton",   resumen: "Una sola instancia compartida (static let shared).",            icono: "person.crop.circle.badge.checkmark", color: .blue,   sesion: "Sesión 11"),
    Patron(nombre: "Delegate",    resumen: "Un objeto delega responsabilidad a otro vía protocol.",          icono: "arrow.triangle.branch",              color: .green,  sesion: "Sesión 11"),
    Patron(nombre: "Observer",    resumen: "Publish-subscribe con NotificationCenter.",                      icono: "antenna.radiowaves.left.and.right",  color: .orange, sesion: "Sesión 11"),
    Patron(nombre: "POP",         resumen: "Protocol-Oriented Programming: protocolos + extensiones.",       icono: "p.circle",                           color: .purple, sesion: "Sesión 11"),
    Patron(nombre: "MVVM",        resumen: "View ↔︎ ViewModel ↔︎ Model, con Repository + DI.",               icono: "rectangle.3.group",                  color: .pink,   sesion: "Sesión 12"),
    Patron(nombre: "Coordinator", resumen: "Saca la navegación fuera de las Views.",                         icono: "map",                                color: .teal,   sesion: "Sesión 12"),
    Patron(nombre:"Patron personalizado", resumen: "RESUMEN PERSONALIZADO", icono: "rectangle.3.offgrid", color: .gray, sesion: "26/06/2026")
]

// MARK: - Vista principal (lista de patrones)

struct PatronesView: View {
    var body: some View {
        List {
            Section {
                ForEach(catalogoPatrones) { patron in
                    NavigationLink(value: patron.nombre) {
                        PatronRow(patron: patron)
                    }
                }
            } header: {
                Text("Patrones de diseño en iOS")
            } footer: {
                Text("Toca un patrón para verlo funcionando en vivo.")
            }
        }
        .navigationTitle("Patrones")
        .navigationDestination(for: String.self) { nombre in
            switch nombre {
            case "Singleton":   SingletonDemoView()
            case "Delegate":    DelegateDemoView()
            case "Observer":    ObserverDemoView()
            case "POP":         POPDemoView()
            case "MVVM":        MVVMDemoView()
            case "Coordinator": CoordinatorDemoView()
            default:            EmptyView()
            }
        }
    }
}

private struct PatronRow: View {
    let patron: Patron

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: patron.icono)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(patron.color, in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(patron.nombre).font(.headline)
                    Spacer()
                    Text(patron.sesion)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Text(patron.resumen)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Componentes reutilizables

/// Tarjeta de sección con título e icono (estilo coherente con DeviceMotionView).
private struct PatronCard<Content: View>: View {
    let titulo: String
    let icono: String
    @ViewBuilder let contenido: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(titulo, systemImage: icono).font(.headline)
            Divider()
            contenido
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

/// Consola que muestra el log de eventos generado por el patrón.
private struct ConsolaLog: View {
    let lineas: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if lineas.isEmpty {
                Text("// Sin eventos todavía…")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(lineas.enumerated()), id: \.offset) { _, linea in
                    Text(linea)
                }
            }
        }
        .font(.system(.caption, design: .monospaced))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.black.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - 1. Singleton

private struct SingletonDemoView: View {
    @State private var nombre = ConfiguracionApp.shared.nombreUsuario
    @State private var modoOscuro = ConfiguracionApp.shared.modoOscuro
    @State private var lecturaConfirmada = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PatronCard(titulo: "Estado compartido", icono: "person.crop.circle.badge.checkmark") {
                    TextField("Nombre de usuario", text: $nombre)
                        .textFieldStyle(.roundedBorder)
                    Toggle("Modo oscuro", isOn: $modoOscuro)
                    Button("Guardar en ConfiguracionApp.shared") {
                        ConfiguracionApp.shared.nombreUsuario = nombre
                        ConfiguracionApp.shared.modoOscuro = modoOscuro
                    }
                    .buttonStyle(.borderedProminent)
                }

                PatronCard(titulo: "Leer desde otra parte de la app", icono: "arrow.down.doc") {
                    Button("Leer ConfiguracionApp.shared") {
                        let c = ConfiguracionApp.shared
                        lecturaConfirmada = "Usuario: \(c.nombreUsuario) · Oscuro: \(c.modoOscuro ? "Sí" : "No")"
                    }
                    .buttonStyle(.bordered)
                    if !lecturaConfirmada.isEmpty {
                        Text(lecturaConfirmada)
                            .font(.system(.callout, design: .monospaced))
                            .foregroundStyle(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ExplicacionPatron(texto: "La misma instancia `ConfiguracionApp.shared` es accesible desde toda la app. El `private init()` impide crear copias. Equivale a un `object` de Kotlin.")
            }
            .padding()
        }
        .navigationTitle("Singleton")
    }
}

// MARK: - 2. Delegate

@Observable
private final class DescargaDemo: DescargaDelegate {
    var log: [String] = []
    var progreso: Double = 0
    var descargando = false
    private let manager = DescargaManager()

    init() { manager.delegate = self }

    func empezar(url: String) {
        log = ["▶️ Iniciando descarga: \(url)"]
        progreso = 0
        descargando = true
        manager.iniciarDescarga(url: url)
    }

    func progresoActualizado(porcentaje: Double) {
        progreso = porcentaje
        log.append("⏳ Progreso: \(Int(porcentaje))%")
    }

    func descargaCompletada(archivo: String) {
        descargando = false
        log.append("✅ Listo: \(archivo)")
    }

    func descargaFallo(error: String) {
        descargando = false
        log.append("❌ Error: \(error)")
    }
}

private struct DelegateDemoView: View {
    @State private var demo = DescargaDemo()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PatronCard(titulo: "DescargaManager → delegate", icono: "arrow.triangle.branch") {
                    ProgressView(value: demo.progreso, total: 100)
                    HStack {
                        Button("Descargar (https ✓)") { demo.empezar(url: "https://ejemplo.com/doc.pdf") }
                            .buttonStyle(.borderedProminent)
                        Button("Descargar (http ✗)") { demo.empezar(url: "http://inseguro.com") }
                            .buttonStyle(.bordered)
                            .tint(.red)
                    }
                    .disabled(demo.descargando)
                }

                PatronCard(titulo: "Eventos del delegado", icono: "list.bullet.rectangle") {
                    ConsolaLog(lineas: demo.log)
                }

                ExplicacionPatron(texto: "`DescargaManager` no sabe quién recibe los avisos: los reenvía a su `delegate` (un `protocol`). El delegado se declara `weak` para evitar retain cycles.")
            }
            .padding()
        }
        .navigationTitle("Delegate")
    }
}

// MARK: - 3. Observer

struct ObserverDemoView: View {
    @State private var mensaje = "Esperando evento…"
    @State private var resumenCarrito = "—"
    @State private var log: [String] = []

    private let sesion = SesionManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PatronCard(titulo: "Emisores (post)", icono: "paperplane") {
                    Button("Cerrar sesión") { sesion.cerrarSesion() }
                        .buttonStyle(.borderedProminent)
                    Button("Actualizar carrito") { sesion.notificarCarrito(items: 3, monto: 599.50) }
                        .buttonStyle(.bordered)
                }

                PatronCard(titulo: "Suscriptores (onReceive)", icono: "antenna.radiowaves.left.and.right") {
                    Text(mensaje).bold()
                    Text("Carrito: \(resumenCarrito)")
                        .font(.system(.callout, design: .monospaced))
                    ConsolaLog(lineas: log)
                }

                ExplicacionPatron(texto: "`SesionManager` publica eventos en el `NotificationCenter` sin conocer a sus oyentes. La vista se suscribe con `.onReceive`. Es el publish-subscribe nativo, anterior a Combine.")
            }
            .padding()
        }
        .navigationTitle("Observer")
        .onReceive(NotificationCenter.default.publisher(for: .usuarioCambiado)) { notification in
            let accion = notification.userInfo?["accion"] as? String ?? ""
            mensaje = "Evento recibido: \(accion)"
            log.append("📨 usuarioCambiado · \(accion)")
        }
        .onReceive(NotificationCenter.default.publisher(for: .carritoActualizado)) { notification in
            if let evento = notification.object as? CarritoEvento {
                resumenCarrito = "\(evento.totalItems) items, $\(evento.montoTotal)"
                log.append("📨 carritoActualizado · \(evento.totalItems) items")
            }
        }
    }
}

// MARK: - 4. POP

private struct POPDemoView: View {
    @State private var resultados: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PatronCard(titulo: "Mismos protocolos, distinto comportamiento", icono: "p.circle") {
                    Button("Ejecutar presentar<T: Saludable>(...)") {
                        let e = Estudiante(nombre: "Ana", id: "A001")
                        let p = ProfesorPOP(nombre: "Alberto")
                        resultados = [
                            "Estudiante usa el default:",
                            "  → \(presentar(e))",
                            "Profesor sobrescribe el default:",
                            "  → \(presentar(p))"
                        ]
                    }
                    .buttonStyle(.borderedProminent)
                    ConsolaLog(lineas: resultados)
                }

                ExplicacionPatron(texto: "`Saludable` da una implementación por defecto vía `extension`. `Estudiante` la hereda; `ProfesorPOP` la sobrescribe. La función genérica `presentar<T: Saludable>` acepta cualquier tipo que cumpla el protocolo.")
            }
            .padding()
        }
        .navigationTitle("POP")
    }
}

// MARK: - 5. MVVM (con Repository + DI)

private struct MVVMDemoView: View {
    @State private var viewModel: ProductosViewModel
    @State private var usandoMock: Bool

    init(repository: ProductoRepository = ProductoRepositoryImpl(), esMock: Bool = false) {
        _viewModel = State(initialValue: ProductosViewModel(repository: repository))
        _usandoMock = State(initialValue: esMock)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PatronCard(titulo: "Inyección de dependencias", icono: "rectangle.3.group") {
                    Text("Repository activo: \(usandoMock ? "Mock (datos de prueba)" : "Impl (latencia simulada)")")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    HStack {
                        Button("Usar Impl") { cambiarRepo(ProductoRepositoryImpl(), mock: false) }
                            .buttonStyle(.borderedProminent)
                            .tint(usandoMock ? .gray : .accentColor)
                        Button("Usar Mock") { cambiarRepo(ProductoRepositoryMock(), mock: true) }
                            .buttonStyle(.borderedProminent)
                            .tint(usandoMock ? .accentColor : .gray)
                    }
                }

                PatronCard(titulo: "View renderiza el ViewModel", icono: "list.bullet") {
                    if viewModel.cargando {
                        ProgressView("Cargando productos…")
                            .frame(maxWidth: .infinity)
                    } else if let error = viewModel.error {
                        Text("Error: \(error)").foregroundStyle(.red)
                    } else if viewModel.productos.isEmpty {
                        Text("Sin productos. Recarga abajo.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.productos) { producto in
                            HStack {
                                Text(producto.nombre)
                                Spacer()
                                Text(producto.precio, format: .currency(code: "MXN"))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Divider()
                        HStack {
                            Text("Total inventario").bold()
                            Spacer()
                            Text(viewModel.totalInventario, format: .currency(code: "MXN")).bold()
                        }
                    }
                    Button("Recargar") {
                        Task { await viewModel.cargarProductos() }
                    }
                    .buttonStyle(.bordered)
                }

                ExplicacionPatron(texto: "La View no tiene lógica de negocio: solo describe UI a partir del `ProductosViewModel` (`@Observable`). El ViewModel recibe su `ProductoRepository` por inyección, así puedes intercambiar Impl ↔︎ Mock sin tocar la vista (esto habilita los tests unitarios).")
            }
            .padding()
        }
        .navigationTitle("MVVM")
        .task { await viewModel.cargarProductos() }
    }

    private func cambiarRepo(_ repo: ProductoRepository, mock: Bool) {
        viewModel = ProductosViewModel(repository: repo)
        usandoMock = mock
        Task { await viewModel.cargarProductos() }
    }
}

// MARK: - 6. Coordinator

private struct CoordinatorDemoView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PatronCard(titulo: "La navegación vive en el Coordinator", icono: "map") {
                    Button("Ver detalle de producto") {
                        coordinator.irADetalle(Producto(id: 1, nombre: "Demo", precio: 100))
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Ir a configuración") {
                        coordinator.irAConfiguracion()
                    }
                    .buttonStyle(.bordered)

                    Button("Mostrar modal") {
                        coordinator.mostrarModalAgregar()
                    }
                    .buttonStyle(.bordered)
                }

                ExplicacionPatron(texto: "El Coordinator decide a qué pantalla ir. La vista solo llama funciones como irADetalle, irAConfiguracion o mostrarModal.")
            }
            .padding()
        }
        .navigationTitle("Coordinator")
        .navigationDestination(item: $coordinator.pantallaActual) { pantalla in
            CoordinatorDestinoView(
                pantalla: pantalla,
                coordinator: coordinator
            )
        }
        .sheet(item: $coordinator.modalActivo) { modal in
            VStack(spacing: 16) {
                switch modal {
                case .agregarProducto:
                    Text("Formulario para agregar producto")
                        .font(.headline)

                case .filtros:
                    Text("Formulario de filtros")
                        .font(.headline)
                }

                Button("Cerrar") {
                    coordinator.cerrarModal()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}

private struct CoordinatorDestinoView: View {
    let pantalla: Pantalla
    @ObservedObject var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            switch pantalla {
            case .detalle(let producto):
                Text("Detalle de \(producto.nombre)")
                    .font(.title2)
                    .bold()
                
                Text(producto.precio, format: .currency(code: "MXN"))
                
            case .configuracion:
                Text("Pantalla de configuración")
                    .font(.title2)
                    .bold()
            }
            
            Button("Regresar al inicio") {
                coordinator.regresarAInicio()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Detalle")
    }
}
// MARK: - Explicación

private struct ExplicacionPatron: View {
    let texto: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .foregroundStyle(.yellow)
            Text(texto)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.yellow.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        PatronesView()
    }
}
