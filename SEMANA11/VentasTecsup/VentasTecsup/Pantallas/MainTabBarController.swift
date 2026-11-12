//
//  MainTabBarController.swift
//  VentasTecsup
//
//  TabBar cuyas pestañas dependen del rol de la sesión activa.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let productos = envolver(ProductosViewController(), titulo: "Productos", icono: "shippingbox")
        let clientes = envolver(ClientesViewController(), titulo: "Clientes", icono: "person.2")
        let cuenta = envolver(CuentaViewController(), titulo: "Cuenta", icono: "person.crop.circle")

        switch SesionUsuario.compartida.rolActual {
        case .vendedor:
            let venta = envolver(NuevaVentaViewController(), titulo: "Venta", icono: "cart.badge.plus")
            let misVentas = envolver(MisVentasViewController(), titulo: "Mis ventas", icono: "list.bullet.rectangle")
            viewControllers = [productos, clientes, venta, misVentas, cuenta]
        case .supervisor, .none:
            viewControllers = [productos, clientes, cuenta]
        }
    }

    private func envolver(_ vc: UIViewController, titulo: String = "", icono: String = "circle") -> UINavigationController {
        vc.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
        return UINavigationController(rootViewController: vc)
    }
}
