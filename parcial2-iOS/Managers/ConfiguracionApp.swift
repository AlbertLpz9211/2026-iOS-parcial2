//
//  ConfiguracionApp.swift
//  parcial2-iOS
//
//  Created by iMac 08 on 25/06/26.
//

import Foundation

final class ConfiguracionApp {
    static let shared = ConfiguracionApp()

    var nombreUsuario: String = "Isai"
    var modoPractica: Bool = true

    private init() {}
}
