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
        let cuenta = envolver(CuentaViewController(), titulo: "Cuenta", icono: "person.crop.circle")
        viewControllers = [cuenta]
    }

    private func envolver(_ vc: UIViewController, titulo: String = "", icono: String = "circle") -> UINavigationController {
        vc.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), tag: 0)
        return UINavigationController(rootViewController: vc)
    }
}
