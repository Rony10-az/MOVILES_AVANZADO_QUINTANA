//
//  SesionUsuario.swift
//  VentasTecsup
//
//  Guarda el Usuario conectado mientras la app está abierta.
//

import UIKit
import CoreData

enum Rol: String {
    case vendedor = "Vendedor"
    case supervisor = "Supervisor"
}

final class SesionUsuario {

    static let compartida = SesionUsuario()
    private init() {}

    /// Usuario que inició sesión; nil si nadie ha entrado o se cerró sesión.
    private(set) var usuarioActual: Usuario?

    var rolActual: Rol? {
        guard let texto = usuarioActual?.rol else { return nil }
        return Rol(rawValue: texto)
    }

    var contexto: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func iniciarSesion(con usuario: Usuario) {
        usuarioActual = usuario
    }

    func cerrarSesion() {
        usuarioActual = nil
    }
}
