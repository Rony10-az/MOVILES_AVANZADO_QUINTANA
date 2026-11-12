//
//  ResumenViewController.swift
//  VentasTecsup
//
//  Pantalla A9 (versión base): indicadores del Supervisor.
//  El gráfico de 7 días, el ranking y el stock bajo se agregan
//  en la rama ia-assisted (nivel Reto).
//

import UIKit
import CoreData

class ResumenViewController: UIViewController {

    private let vendidoHoyLabel = UILabel()
    private let vendidoMesLabel = UILabel()
    private let igvMesLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        view.backgroundColor = .systemBackground
        construirInterfaz()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarIndicadores()
    }

    private func construirInterfaz() {
        let saludo = UILabel()
        saludo.text = "Hola, \(SesionUsuario.compartida.usuarioActual?.nombre ?? "")"
        saludo.font = .boldSystemFont(ofSize: 22)

        func tarjeta(titulo: String, valor: UILabel) -> UIStackView {
            let tituloLabel = UILabel()
            tituloLabel.text = titulo
            tituloLabel.font = .systemFont(ofSize: 13)
            tituloLabel.textColor = .secondaryLabel
            valor.font = .boldSystemFont(ofSize: 22)
            let col = UIStackView(arrangedSubviews: [tituloLabel, valor])
            col.axis = .vertical
            col.spacing = 4
            return col
        }

        let filaIndicadores = UIStackView(arrangedSubviews: [
            tarjeta(titulo: "Vendido hoy", valor: vendidoHoyLabel),
            tarjeta(titulo: "Vendido el mes", valor: vendidoMesLabel)
        ])
        filaIndicadores.axis = .horizontal
        filaIndicadores.distribution = .fillEqually

        let igvFila = tarjeta(titulo: "IGV del mes (ventas)", valor: igvMesLabel)

        let stack = UIStackView(arrangedSubviews: [saludo, filaIndicadores, igvFila])
        stack.axis = .vertical
        stack.spacing = 28
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }

    private func cargarIndicadores() {
        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
        solicitud.predicate = NSPredicate(format: "anulada == NO")
        guard let ventas = try? contexto.fetch(solicitud) else { return }

        let calendario = Calendar.current
        let deHoy = ventas.filter { $0.fecha.map { calendario.isDateInToday($0) } ?? false }
        let delMes = ventas.filter { venta in
            guard let fecha = venta.fecha else { return false }
            return calendario.isDate(fecha, equalTo: Date(), toGranularity: .month)
        }

        vendidoHoyLabel.text = deHoy.reduce(0) { $0 + $1.total }.comoMoneda
        vendidoMesLabel.text = delMes.reduce(0) { $0 + $1.total }.comoMoneda
        igvMesLabel.text = delMes.reduce(0) { $0 + $1.igv }.comoMoneda
    }
}
