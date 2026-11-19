//
//  LoginViewController.swift
//  VentasTecsup
//
//  Pantalla A1: inicio de sesión. Interfaz en Main.storyboard.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet private weak var usuarioField: UITextField!
    @IBOutlet private weak var claveField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var ingresarButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        var config = UIButton.Configuration.filled()
        config.title = "Ingresar"
        config.cornerStyle = .medium
        ingresarButton.configuration = config

        errorLabel.isHidden = true
    }

    @IBAction private func ingresarTocado(_ sender: Any) {
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

    @IBAction private func crearCuentaTocada(_ sender: Any) {
        navigationController?.isNavigationBarHidden = false
        let registro: RegistroViewController = Pantalla.instanciar("Registro")
        navigationController?.pushViewController(registro, animated: true)
    }
}
