//
//  LoginViewController.swift
//  VentasTecsup
//
//  Pantalla A1: inicio de sesión.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    private let logo: UILabel = {
        let label = UILabel()
        label.text = "🛒"
        label.font = .systemFont(ofSize: 64)
        label.textAlignment = .center
        return label
    }()

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.text = "Ventas Tecsup"
        label.font = .boldSystemFont(ofSize: 26)
        label.textAlignment = .center
        return label
    }()

    private let subtituloLabel: UILabel = {
        let label = UILabel()
        label.text = "Inicia sesión para continuar"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let usuarioField: UITextField = {
        let field = UITextField()
        field.placeholder = "Usuario"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }()

    private let claveField: UITextField = {
        let field = UITextField()
        field.placeholder = "Clave"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let ingresarButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Ingresar"
        config.cornerStyle = .medium
        let button = UIButton(configuration: config)
        return button
    }()

    private let crearCuentaButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("¿Primera vez? Crear cuenta", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        construirInterfaz()
        ingresarButton.addTarget(self, action: #selector(ingresarTocado), for: .touchUpInside)
        crearCuentaButton.addTarget(self, action: #selector(crearCuentaTocada), for: .touchUpInside)
    }

    private func construirInterfaz() {
        let stack = UIStackView(arrangedSubviews: [
            logo, tituloLabel, subtituloLabel,
            espaciador(16),
            usuarioField, claveField, errorLabel,
            espaciador(8),
            ingresarButton, crearCuentaButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            ingresarButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    private func espaciador(_ altura: CGFloat) -> UIView {
        let vista = UIView()
        vista.heightAnchor.constraint(equalToConstant: altura).isActive = true
        return vista
    }

    @objc private func ingresarTocado() {
        errorLabel.isHidden = true
        let usuarioTexto = (usuarioField.text ?? "").trimmingCharacters(in: .whitespaces)
        let claveTexto = claveField.text ?? ""

        guard !usuarioTexto.isEmpty, !claveTexto.isEmpty else {
            mostrarError("Ingresa tu usuario y clave.")
            return
        }

        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        solicitud.predicate = NSPredicate(format: "usuario ==[c] %@", usuarioTexto)
        solicitud.fetchLimit = 1

        do {
            guard let usuario = try contexto.fetch(solicitud).first, usuario.clave == claveTexto else {
                mostrarError("Usuario o clave incorrectos")
                return
            }
            SesionUsuario.compartida.iniciarSesion(con: usuario)
            SceneDelegate.mostrarPantallaInicial()
        } catch {
            mostrarError("No se pudo iniciar sesión: \(error.localizedDescription)")
        }
    }

    private func mostrarError(_ texto: String) {
        errorLabel.text = "⚠️ \(texto)"
        errorLabel.isHidden = false
    }

    @objc private func crearCuentaTocada() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }
}
