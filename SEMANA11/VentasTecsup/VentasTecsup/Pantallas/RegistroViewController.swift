//
//  RegistroViewController.swift
//  VentasTecsup
//
//  Pantalla A2: crear cuenta (registro).
//

import UIKit
import CoreData

class RegistroViewController: UIViewController {

    private let nombreField: UITextField = {
        let field = UITextField()
        field.placeholder = "Nombre completo"
        field.borderStyle = .roundedRect
        return field
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
        field.placeholder = "Clave (mínimo 6 caracteres)"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    private let confirmarClaveField: UITextField = {
        let field = UITextField()
        field.placeholder = "Confirmar clave"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    private let rolControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Rol.vendedor.rawValue, Rol.supervisor.rawValue])
        control.selectedSegmentIndex = 0
        return control
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

    private let registrarmeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Registrarme"
        config.cornerStyle = .medium
        return UIButton(configuration: config)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        view.backgroundColor = .systemBackground
        construirInterfaz()
        registrarmeButton.addTarget(self, action: #selector(registrarmeTocado), for: .touchUpInside)
    }

    private func construirInterfaz() {
        let etiquetaDatos = UILabel()
        etiquetaDatos.text = "Datos del alumno"
        etiquetaDatos.font = .boldSystemFont(ofSize: 15)

        let etiquetaRol = UILabel()
        etiquetaRol.text = "Tu rol"
        etiquetaRol.font = .boldSystemFont(ofSize: 15)

        let stack = UIStackView(arrangedSubviews: [
            nombreField, usuarioField, claveField, confirmarClaveField,
            etiquetaRol, rolControl,
            errorLabel, registrarmeButton
        ])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            registrarmeButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    @objc private func registrarmeTocado() {
        errorLabel.isHidden = true

        let nombre = (nombreField.text ?? "").trimmingCharacters(in: .whitespaces)
        let usuarioTexto = (usuarioField.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = claveField.text ?? ""
        let confirmacion = confirmarClaveField.text ?? ""

        guard !nombre.isEmpty, !usuarioTexto.isEmpty else {
            return mostrarError("Completa nombre y usuario.")
        }
        guard clave.count >= 6 else {
            return mostrarError("La clave debe tener al menos 6 caracteres.")
        }
        guard clave == confirmacion else {
            return mostrarError("La clave y su confirmación no coinciden.")
        }

        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        solicitud.predicate = NSPredicate(format: "usuario ==[c] %@", usuarioTexto)
        solicitud.fetchLimit = 1

        do {
            if try contexto.fetch(solicitud).first != nil {
                return mostrarError("Ese usuario ya existe. Elige otro.")
            }

            let rol = rolControl.selectedSegmentIndex == 0 ? Rol.vendedor : Rol.supervisor
            let nuevoUsuario = Usuario(context: contexto)
            nuevoUsuario.nombre = nombre
            nuevoUsuario.usuario = usuarioTexto
            nuevoUsuario.clave = clave
            nuevoUsuario.rol = rol.rawValue

            try contexto.save()

            SesionUsuario.compartida.iniciarSesion(con: nuevoUsuario)
            SceneDelegate.mostrarPantallaInicial()
        } catch {
            mostrarError("No se pudo registrar: \(error.localizedDescription)")
        }
    }

    private func mostrarError(_ texto: String) {
        errorLabel.text = "⚠️ \(texto)"
        errorLabel.isHidden = false
    }
}
