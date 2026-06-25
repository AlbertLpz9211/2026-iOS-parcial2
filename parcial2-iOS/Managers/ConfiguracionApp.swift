//
//  ConfiguracionApp.swift
//  parcial2-iOS
//
//  Created by iMac 11 on 25/06/26.
//

import Foundation

final class ConfiguracionApp {
    static let shared = ConfiguracionApp()
    
    var nombreUsuario: String = "Pelon"
    var modoPractica: Bool = true
    
    private init() {}
}
