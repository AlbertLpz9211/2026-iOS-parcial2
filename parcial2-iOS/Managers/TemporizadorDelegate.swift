//
//  TemporizadorDelegate.swift
//  parcial2-iOS
//
//  Created by iMac 11 on 25/06/26.
//

import Foundation

protocol TemporizadorDelegate: AnyObject {
    func tiempoActualizado(segundos: Int)
    func tiempoTerminado()
}

final class TemporizadorManager {
    weak var delegate: TemporizadorDelegate?

    private var timer: Timer?
    private var segundosRestantes = 10

    func iniciar() {
        detener()
        segundosRestantes = 10
        delegate?.tiempoActualizado(segundos: segundosRestantes)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.segundosRestantes -= 1
            self.delegate?.tiempoActualizado(segundos: self.segundosRestantes)

            if self.segundosRestantes == 0 {
                self.detener()
                self.delegate?.tiempoTerminado()
            }
        }
    }

    func detener() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        detener()
    }
}
