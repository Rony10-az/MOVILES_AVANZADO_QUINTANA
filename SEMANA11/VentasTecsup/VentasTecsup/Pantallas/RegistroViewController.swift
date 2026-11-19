//
//  RegistroViewController.swift
//  VentasTecsup
//
//  Pantalla A2: crear cuenta (registro). Interfaz en Main.storyboard.
//

import UIKit
import CoreData

class RegistroViewController: UIViewController {

    @IBOutlet private weak var nombreField: UITextField!
    @IBOutlet private weak var usuarioField: UITextField!
    @IBOutlet private weak var claveField: UITextField!
    @IBOutlet private weak var confirmarClaveField: UITextField!
    @IBOutlet private weak var rolControl: UISegmentedControl!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var registrarmeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"

        var config = UIButton.Configuration.filled()
        config.title = "Registrarme"
        config.cornerStyle = .medium
        registrarmeButton.configuration = config

        errorLabel.isHidden = true
    }

    @IBAction private func registrarmeTocado(_ sender: Any) {
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
