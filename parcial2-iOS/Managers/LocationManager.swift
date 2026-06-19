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
    var estadoPermiso: CLAuthorizationStatus = .notDetermined
    var error: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        estadoPermiso = manager.authorizationStatus
    }

    func solicitarPermiso() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            iniciarActualizaciones()
        case .denied, .restricted:
            detenerActualizaciones()
        @unknown default:
            detenerActualizaciones()
        }
    }

    func iniciarActualizaciones() {
        manager.startUpdatingLocation()
    }

    func detenerActualizaciones() {
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        estadoPermiso = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            error = nil
            iniciarActualizaciones()
        case .denied, .restricted:
            ubicacion = nil
            detenerActualizaciones()
        case .notDetermined:
            break
        @unknown default:
            detenerActualizaciones()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let ultimaUbicacion = locations.last else { return }
        ubicacion = ultimaUbicacion.coordinate
        error = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error.localizedDescription
    }

    func monitorearZona(centro: CLLocationCoordinate2D, radio: CLLocationDistance, identificador: String) {
        let region = CLCircularRegion(center: centro, radius: radio, identifier: identificador)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        manager.startMonitoring(for: region)
    }
}
