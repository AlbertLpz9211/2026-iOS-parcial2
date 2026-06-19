//
//  AcelerometoManager.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import CoreMotion
import Observation
import Foundation

@Observable
class AcelerometroManager {
    private let motionManager = CMMotionManager()
    var x: Double = 0
    var y: Double = 0
    var z: Double = 0

    #if targetEnvironment(simulator)
    private var timer: Timer?
    private var t: Double = 0
    #endif

    func iniciar() {
        #if targetEnvironment(simulator)
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.t += 0.2
            self.x = sin(self.t)
            self.y = cos(self.t * 0.7)
            self.z = sin(self.t * 0.4) * 0.5 - 0.9  // simula gravedad en Z
        }
        #else
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let data else { return }
            self?.x = data.acceleration.x
            self?.y = data.acceleration.y
            self?.z = data.acceleration.z
        }
        #endif
    }

    func detener() {
        #if targetEnvironment(simulator)
        timer?.invalidate()
        timer = nil
        #else
        motionManager.stopAccelerometerUpdates()
        #endif
    }
}
