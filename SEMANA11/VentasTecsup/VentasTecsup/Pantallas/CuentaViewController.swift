//
//  CuentaViewController.swift
//  VentasTecsup
//
//  Pestaña Cuenta: nombre, usuario, rol y cerrar sesión (ambos roles).
//

import UIKit

class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cuenta"
        view.backgroundColor = .systemBackground
        construirInterfaz()
    }

    private func construirInterfaz() {
        let usuario = SesionUsuario.compartida.usuarioActual

        let nombreLabel = etiqueta(titulo: "Nombre", valor: usuario?.nombre ?? "-")
        let usuarioLabel = etiqueta(titulo: "Usuario", valor: usuario?.usuario ?? "-")
        let rolLabel = etiqueta(titulo: "Rol", valor: usuario?.rol ?? "-")

        var config = UIButton.Configuration.filled()
        config.title = "Cerrar sesión"
        config.baseBackgroundColor = .systemRed
        config.cornerStyle = .medium
        let cerrarSesionButton = UIButton(configuration: config)
        cerrarSesionButton.addTarget(self, action: #selector(cerrarSesionTocado), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nombreLabel, usuarioLabel, rolLabel, espaciador(), cerrarSesionButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            cerrarSesionButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    private func etiqueta(titulo: String, valor: String) -> UIView {
        let contenedor = UIStackView()
        contenedor.axis = .vertical
        contenedor.spacing = 2

        let tituloLabel = UILabel()
        tituloLabel.text = titulo
        tituloLabel.font = .systemFont(ofSize: 13)
        tituloLabel.textColor = .secondaryLabel

        let valorLabel = UILabel()
        valorLabel.text = valor
        valorLabel.font = .boldSystemFont(ofSize: 18)

        contenedor.addArrangedSubview(tituloLabel)
        contenedor.addArrangedSubview(valorLabel)
        return contenedor
    }

    private func espaciador() -> UIView {
        let vista = UIView()
        vista.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return vista
    }

    @objc private func cerrarSesionTocado() {
        SesionUsuario.compartida.cerrarSesion()
        SceneDelegate.mostrarPantallaInicial()
    }
}
