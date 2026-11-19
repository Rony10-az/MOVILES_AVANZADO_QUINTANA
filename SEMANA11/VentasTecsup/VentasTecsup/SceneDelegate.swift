//
//  SceneDelegate.swift
//  VentasTecsup
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = SceneDelegate.pantallaInicial()
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    /// Decide qué pantalla mostrar según si hay sesión activa.
    static func pantallaInicial() -> UIViewController {
        if SesionUsuario.compartida.usuarioActual != nil {
            return MainTabBarController()
        } else {
            let login: LoginViewController = Pantalla.instanciar("Login")
            return UINavigationController(rootViewController: login)
        }
    }

    /// Reemplaza la raíz de la ventana (usado al iniciar y cerrar sesión).
    static func mostrarPantallaInicial(animado: Bool = true) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }

        let nuevaRaiz = pantallaInicial()
        if animado {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = nuevaRaiz
            })
        } else {
            window.rootViewController = nuevaRaiz
        }
    }
}
