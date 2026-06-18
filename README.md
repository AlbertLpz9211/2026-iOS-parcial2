# Parcial 2 — Desarrollo Móvil iOS
### Instituto de Estudios Superiores Nueva Galicia · Swift + SwiftUI + Xcode

Repositorio de trabajo del segundo parcial del curso de **Desarrollo Móvil**. Durante las sesiones del 18 de junio al 10 de julio de 2026, los alumnos construyen progresivamente una base sólida en iOS nativo, partiendo de sensores de hardware hasta una app completa con arquitectura MVVM, consumo de APIs REST y persistencia de datos.

---

## Enfoque del parcial

El Parcial 2 es 100% iOS nativo. Cada sesión introduce un bloque conceptual con código completo y una tarea práctica que el alumno sube a una rama individual de este repositorio. La progresión está diseñada para que los conceptos se acumulen: los patrones de la Sesión 11-12 se aplican en el networking de la 13-14, y todo converge en el laboratorio integrador de la Sesión 16.

---

## Plan de sesiones

| Sesión | Fecha | Tema | Rama de entrega |
|--------|-------|------|-----------------|
| 9  | 18/06/2026 | Core Location + Core Motion (GPS, acelerómetro, giroscopio, magnetómetro) | `sesion-09-sensores` |
| 10 | 19/06/2026 | Proceso de publicación en App Store (firma, Archive, App Store Connect) | `sesion-10-appstore` |
| 11 | 25/06/2026 | Patrones nativos de Apple: MVC, Delegate, Singleton, Observer, POP | `sesion-11-patrones-parte1` |
| 12 | 26/06/2026 | Patrones modernos: MVVM, Repository, Dependency Injection, Coordinator | `sesion-12-patrones-parte2` |
| 13 | 02/07/2026 | Consumo de APIs REST — URLSession + Codable | `sesion-13-networking-parte1` |
| 14 | 03/07/2026 | Networking avanzado — APIClient genérico, CRUD, Combine | `sesion-14-networking-parte2` |
| 15 | 09/07/2026 | Persistencia: UserDefaults, Keychain, Core Data, FileManager | `sesion-15-persistencia` |
| 16 | 10/07/2026 | Laboratorio integrador final | `sesion-16-lab-final` |

---

## Stack tecnológico

- **Lenguaje:** Swift 5.9+
- **UI Framework:** SwiftUI (`@State`, `@Binding`, `@ObservedObject`, `@EnvironmentObject`)
- **Persistencia:** UserDefaults · Keychain · Core Data · FileManager
- **Networking:** URLSession · Codable · Combine
- **Hardware:** Core Location · Core Motion
- **IDE:** Xcode 16.x · macOS Sonoma/Sequoia

---

## Cómo entregar cada tarea

1. Clona o actualiza el repositorio: `git clone <URL> && git pull origin main`
2. Crea una rama con el nombre exacto de la tabla anterior:

```bash
git checkout main && git pull origin main
git checkout -b sesion-09-sensores
```

3. Coloca tu trabajo dentro de una carpeta con el mismo nombre de la rama (`sesion-09-sensores/`).
4. Haz commit y push:

```bash
git add .
git commit -m "Sesion 9: sensores GPS y Core Motion"
git push origin sesion-09-sensores
```

5. Abre un **Pull Request** hacia `main` en GitHub — el PR abierto es tu evidencia de entrega. Describe en el cuerpo del PR qué implementaste.

> **Una rama por sesión.** No se aceptan ramas con tareas de múltiples sesiones mezcladas.

---

## Requisitos de entorno

| Requisito | Detalle |
|-----------|---------|
| Sistema operativo | macOS Sonoma 14+ o Sequoia 15 |
| IDE | Xcode 16.x (gratis en Mac App Store) |
| Cuenta Apple | Apple ID gratuito — suficiente para el Simulador y dispositivo propio |
| Dispositivo físico | Recomendado para Sesión 9 (sensores reales: acelerómetro, GPS) |

---

## Arquitectura objetivo (Sesiones 12–16)

```
App/
├── Models/          # Structs puros, Codable
├── Network/         # APIClient genérico, HTTPMethod
├── Repositories/    # Protocolo + implementación + mock
├── Persistence/     # UserDefaults, Keychain, Core Data
├── Location/        # LocationManager (ObservableObject)
├── ViewModels/      # @MainActor, @Published, async/await
├── Coordinator/     # AppCoordinator, NavigationStack
└── Views/           # SwiftUI puro, sin lógica de negocio
```

La arquitectura escala sesión a sesión: se introduce en la 12, se ejerce en la 13-14, se completa en la 16.

---

*Desarrollo Móvil · Segundo Parcial · Instituto de Estudios Superiores Nueva Galicia*
