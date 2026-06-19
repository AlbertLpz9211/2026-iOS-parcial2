//
//  GiroscopioManager.swift
//  parcial2-iOS
//
//  Created by Alberto Lopez on 19/06/26.
//

import CoreMotion
import Foundation
import Observation

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
        timer?.invalidate()
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
