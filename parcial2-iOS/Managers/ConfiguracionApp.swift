//
//  ConfiguracionApp.swift
//  parcial2-iOS
//
//  Created by iMac 12 on 26/06/26.
//

import Foundation

final class ConfiguracionApp {
    static let shared = ConfiguracionApp()

    var nombreUsuario: String = "Alondra"
    var modoPractica: Bool = true

    private init() {}
}
