//
//  Pantalla.swift
//  VentasTecsup
//
//  Acceso compartido a Main.storyboard para instanciar pantallas por su Storyboard ID.
//

import UIKit

enum Pantalla {
    static let principal = UIStoryboard(name: "Main", bundle: nil)

    static func instanciar<T: UIViewController>(_ identificador: String) -> T {
        principal.instantiateViewController(withIdentifier: identificador) as! T
    }
}
