//
//  MainTabBarController.swift
//  VentasTecsup
//
//  TabBar cuyas pestañas dependen del rol de la sesión activa.
//  Cada pestaña se instancia desde Main.storyboard por su Storyboard ID.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let productos = envolver("Productos", titulo: "Productos", icono: "shippingbox")
        let clientes = envolver("Clientes", titulo: "Clientes", icono: "person.2")
        let cuenta = envolver("Cuenta", titulo: "Cuenta", icono: "person.crop.circle")

        switch SesionUsuario.compartida.rolActual {
        case .vendedor:
            let venta = envolver("NuevaVenta", titulo: "Venta", icono: "cart.badge.plus")
            let misVentas = envolver("MisVentas", titulo: "Mis ventas", icono: "list.bullet.rectangle")
            viewControllers = [productos, clientes, venta, misVentas, cuenta]
        case .supervisor:
            let resumen = envolver("Resumen", titulo: "Resumen", icono: "chart.bar")
            let ventas = envolver("VentasEquipo", titulo: "Ventas", icono: "list.bullet.rectangle")
            viewControllers = [resumen, ventas, productos, clientes, cuenta]
        case .none:
            viewControllers = [productos, clientes, cuenta]
        }
    }

    private func envolver(_ identificador: String, titulo: String = "", icono: String = "circle") -> UINavigationController {
        let vc: UIViewController = Pantalla.instanciar(identificador)
        vc.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
        return UINavigationController(rootViewController: vc)
    }
}
