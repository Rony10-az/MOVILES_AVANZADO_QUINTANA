//
//  CuentaViewController.swift
//  VentasTecsup
//
//  Pestaña Cuenta: nombre, usuario, rol y cerrar sesión. Interfaz en Main.storyboard.
//

import UIKit

class CuentaViewController: UIViewController {

    @IBOutlet private weak var nombreValorLabel: UILabel!
    @IBOutlet private weak var usuarioValorLabel: UILabel!
    @IBOutlet private weak var rolValorLabel: UILabel!
    @IBOutlet private weak var cerrarSesionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cuenta"

        var config = UIButton.Configuration.filled()
        config.title = "Cerrar sesión"
        config.baseBackgroundColor = .systemRed
        config.cornerStyle = .medium
        cerrarSesionButton.configuration = config

        let usuario = SesionUsuario.compartida.usuarioActual
        nombreValorLabel.text = usuario?.nombre ?? "-"
        usuarioValorLabel.text = usuario?.usuario ?? "-"
        rolValorLabel.text = usuario?.rol ?? "-"
    }

    @IBAction private func cerrarSesionTocado(_ sender: Any) {
        SesionUsuario.compartida.cerrarSesion()
        SceneDelegate.mostrarPantallaInicial()
    }
}
