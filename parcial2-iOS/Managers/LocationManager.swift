//
//  LocationManager.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    var ubicacion: CLLocationCoordinate2D?
    var altitud: Double?
    var velocidad: Double?
    var estadoPermiso: CLAuthorizationStatus = .notDetermined
    var error: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func solicitarPermiso() {
        manager.requestWhenInUseAuthorization()
    }

    func solicitarPermisoSiempre() {
        manager.requestAlwaysAuthorization()
    }

    func iniciarActualizaciones() {
        manager.startUpdatingLocation()
    }

    func detenerActualizaciones() {
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        estadoPermiso = manager.authorizationStatus
        if estadoPermiso == .authorizedWhenInUse || estadoPermiso == .authorizedAlways {
            iniciarActualizaciones()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let ultima = locations.last else { return }
        ubicacion = ultima.coordinate
        altitud = ultima.altitude
        velocidad = max(ultima.speed, 0)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error.localizedDescription
    }

    // MARK: - Geofencing
    func monitorearZona(centro: CLLocationCoordinate2D, radio: CLLocationDistance, identificador: String) {
        let region = CLCircularRegion(center: centro, radius: radio, identifier: identificador)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        manager.startMonitoring(for: region)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("✅ Entraste a la zona: \(region.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("🚪 Saliste de la zona: \(region.identifier)")
    }
}
