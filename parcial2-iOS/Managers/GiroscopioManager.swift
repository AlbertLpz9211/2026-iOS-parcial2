//
//  GiroscopioManager.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import CoreMotion
import Observation
import Foundation

@Observable
class GiroscopioManager {
    private let motionManager = CMMotionManager()
    var rotacionX: Double = 0
    var rotacionY: Double = 0
    var rotacionZ: Double = 0

    #if targetEnvironment(simulator)
    private var timer: Timer?
    private var t: Double = 0
    #endif

    func iniciar() {
        #if targetEnvironment(simulator)
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.t += 0.2
            self.rotacionX = sin(self.t * 1.3) * 0.5
            self.rotacionY = cos(self.t * 0.9) * 0.3
            self.rotacionZ = sin(self.t * 0.5) * 0.2
        }
        #else
        guard motionManager.isGyroAvailable else { return }
        motionManager.gyroUpdateInterval = 0.2
        motionManager.startGyroUpdates(to: .main) { [weak self] data, _ in
            guard let data else { return }
            self?.rotacionX = data.rotationRate.x
            self?.rotacionY = data.rotationRate.y
            self?.rotacionZ = data.rotationRate.z
        }
        #endif
    }

    func detener() {
        #if targetEnvironment(simulator)
        timer?.invalidate()
        timer = nil
        #else
        motionManager.stopGyroUpdates()
        #endif
    }
}

@Observable
class MagnetometroManager {
    private let motionManager = CMMotionManager()
    var rumbo: Double = 0

    #if targetEnvironment(simulator)
    private var timer: Timer?
    private var t: Double = 0
    #endif

    func iniciar() {
        #if targetEnvironment(simulator)
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.t += 0.2
            // rumbo simulado que gira lentamente entre 0° y 360°
            self.rumbo = (self.t * 10).truncatingRemainder(dividingBy: 360)
        }
        #else
        guard motionManager.isMagnetometerAvailable else { return }
        motionManager.magnetometerUpdateInterval = 0.2
        motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, _ in
            guard let data else { return }
            let campo = data.magneticField
            var rumbo = atan2(campo.y, campo.x) * 180 / .pi
            if rumbo < 0 { rumbo += 360 }
            self?.rumbo = rumbo
        }
        #endif
    }

    func detener() {
        #if targetEnvironment(simulator)
        timer?.invalidate()
        timer = nil
        #else
        motionManager.stopMagnetometerUpdates()
        #endif
    }
}

@Observable
class DeviceMotionManager {
    private let motionManager = CMMotionManager()
    var pitch: Double = 0
    var roll: Double = 0
    var yaw: Double = 0
    var aceleracionX: Double = 0
    var aceleracionY: Double = 0
    var aceleracionZ: Double = 0

    #if targetEnvironment(simulator)
    private var timer: Timer?
    private var t: Double = 0
    #endif

    func iniciar() {
        #if targetEnvironment(simulator)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.t += 0.1
            self.pitch = sin(self.t * 0.8) * 30        // oscila ±30°
            self.roll  = cos(self.t * 0.6) * 20        // oscila ±20°
            self.yaw   = (self.t * 15).truncatingRemainder(dividingBy: 360)
            self.aceleracionX = sin(self.t * 2) * 0.1
            self.aceleracionY = cos(self.t * 1.5) * 0.1
            self.aceleracionZ = sin(self.t * 3) * 0.05
        }
        #else
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion else { return }
            self?.pitch = motion.attitude.pitch * 180 / .pi
            self?.roll  = motion.attitude.roll  * 180 / .pi
            self?.yaw   = motion.attitude.yaw   * 180 / .pi
            self?.aceleracionX = motion.userAcceleration.x
            self?.aceleracionY = motion.userAcceleration.y
            self?.aceleracionZ = motion.userAcceleration.z
        }
        #endif
    }

    func detener() {
        #if targetEnvironment(simulator)
        timer?.invalidate()
        timer = nil
        #else
        motionManager.stopDeviceMotionUpdates()
        #endif
    }
}

@Observable
class DetectorCaidaManager {
    private let motionManager = CMMotionManager()
    var alertaCaida = false

    private let umbral = 2.5

    #if targetEnvironment(simulator)
    private var timer: Timer?
    private var t: Double = 0
    #endif

    func iniciar() {
        #if targetEnvironment(simulator)
        // En el simulador dispara una caída falsa cada 8 segundos para poder probar el alert
        timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { [weak self] _ in
            self?.alertaCaida = true
        }
        #else
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.05
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion, let self else { return }
            let a = motion.userAcceleration
            let magnitud = sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
            if magnitud > self.umbral {
                self.alertaCaida = true
            }
        }
        #endif
    }

    func detener() {
        #if targetEnvironment(simulator)
        timer?.invalidate()
        timer = nil
        #else
        motionManager.stopDeviceMotionUpdates()
        #endif
    }

    func reiniciarAlerta() {
        alertaCaida = false
    }
}
