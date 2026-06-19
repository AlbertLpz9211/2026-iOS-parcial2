//
//  DeviceMotionManager.swift
//  parcial2-iOS
//
//  Created by iMac 12 on 19/06/26.
//

import CoreMotion
import Foundation
import Observation

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
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.t += 0.1
            self.pitch = sin(self.t * 0.8) * 30
            self.roll = cos(self.t * 0.6) * 20
            self.yaw = (self.t * 15).truncatingRemainder(dividingBy: 360)
            self.aceleracionX = sin(self.t * 2) * 0.1
            self.aceleracionY = cos(self.t * 1.5) * 0.1
            self.aceleracionZ = sin(self.t * 3) * 0.05
        }
#else
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, _ in
            guard let deviceMotion else { return }
            self?.pitch = deviceMotion.attitude.pitch * 180 / .pi
            self?.roll = deviceMotion.attitude.roll * 180 / .pi
            self?.yaw = deviceMotion.attitude.yaw * 180 / .pi
            self?.aceleracionX = deviceMotion.userAcceleration.x
            self?.aceleracionY = deviceMotion.userAcceleration.y
            self?.aceleracionZ = deviceMotion.userAcceleration.z
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
