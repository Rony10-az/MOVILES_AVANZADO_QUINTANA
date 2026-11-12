//
//  VentasEquipoViewController.swift
//  VentasTecsup
//
//  Pantalla A7 (Ventas del equipo) y A8 (Anular venta): el Supervisor
//  ve todas las ventas, filtra por vendedor y puede anular con motivo.
//

import UIKit
import CoreData

class VentasEquipoViewController: UITableViewController {

    private var ventas: [Venta] = []
    private var vendedores: [String] = ["Todos"]
    private let buscador = UISearchController(searchResultsController: nil)
    private var vendedorControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ventas del equipo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")

        navigationItem.searchController = buscador
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"

        vendedorControl = UISegmentedControl(items: vendedores)
        vendedorControl.selectedSegmentIndex = 0
        vendedorControl.addTarget(self, action: #selector(filtroCambiado), for: .valueChanged)
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44))
        vendedorControl.frame = contenedor.bounds.insetBy(dx: 12, dy: 4)
        vendedorControl.autoresizingMask = [.flexibleWidth]
        contenedor.addSubview(vendedorControl)
        tableView.tableHeaderView = contenedor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarVentas()
    }

    private func cargarVentas() {
        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
        solicitud.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        do {
            let todas = try contexto.fetch(solicitud)
            actualizarVendedores(todas)
            ventas = aplicarFiltros(todas)
            tableView.reloadData()
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudieron cargar las ventas: \(error.localizedDescription)")
        }
    }

    private func actualizarVendedores(_ todas: [Venta]) {
        let nombres = ["Todos"] + Array(Set(todas.compactMap { $0.vendedor?.nombre })).sorted()
        if nombres != vendedores {
            vendedores = nombres
            vendedorControl.removeAllSegments()
            for (i, nombre) in vendedores.enumerated() {
                vendedorControl.insertSegment(withTitle: nombre, at: i, animated: false)
            }
            vendedorControl.selectedSegmentIndex = 0
        }
    }

    private func aplicarFiltros(_ todas: [Venta]) -> [Venta] {
        var resultado = todas
        if vendedorControl.selectedSegmentIndex > 0 {
            let nombreElegido = vendedores[vendedorControl.selectedSegmentIndex]
            resultado = resultado.filter { $0.vendedor?.nombre == nombreElegido }
        }
        if let texto = buscador.searchBar.text, !texto.isEmpty {
            resultado = resultado.filter { ($0.cliente?.nombre ?? "").localizedCaseInsensitiveContains(texto) }
        }
        return resultado
    }

    @objc private func filtroCambiado() {
        cargarVentas()
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let venta = ventas[indexPath.row]
        var config = celda.defaultContentConfiguration()
        let fechaTexto = venta.fecha.map { DateFormatter.localizedString(from: $0, dateStyle: .short, timeStyle: .none) } ?? ""
        let textoBase = "\(venta.cliente?.nombre ?? "-") · \(venta.vendedor?.nombre ?? "-")"

        if venta.anulada {
            config.attributedText = NSAttributedString(string: textoBase, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            config.secondaryText = "Anulada: \(venta.motivoAnulacion ?? "") · \(fechaTexto)"
            config.secondaryTextProperties.color = .systemRed
        } else {
            config.text = textoBase
            config.secondaryText = "\(venta.producto?.nombre ?? "-") × \(venta.cantidad) · \(fechaTexto) · \(venta.total.comoMoneda)"
        }
        celda.contentConfiguration = config
        celda.selectionStyle = .none
        return celda
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        !ventas[indexPath.row].anulada
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let anular = UITableViewRowAction(style: .destructive, title: "Anular") { [weak self] _, indexPath in
            self?.pedirMotivoYAnular(venta: self!.ventas[indexPath.row])
        }
        return [anular]
    }

    // MARK: - Anular (A8)

    private func pedirMotivoYAnular(venta: Venta) {
        let resumen = "\(venta.producto?.nombre ?? "") × \(venta.cantidad) · \(venta.total.comoMoneda)\nEl stock se devolverá."
        let alerta = UIAlertController(title: "Anular venta", message: resumen, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Motivo (obligatorio)" }

        let anularAccion = UIAlertAction(title: "Anular", style: .destructive) { [weak self, weak alerta] _ in
            guard let self else { return }
            let motivo = (alerta?.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespaces)
            guard !motivo.isEmpty else {
                self.mostrarAlerta(titulo: "Falta el motivo", mensaje: "Escribe un motivo para anular la venta.")
                return
            }
            self.anular(venta: venta, motivo: motivo)
        }
        alerta.addAction(anularAccion)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alerta, animated: true)
    }

    private func anular(venta: Venta, motivo: String) {
        let contexto = SesionUsuario.compartida.contexto
        venta.anulada = true
        venta.motivoAnulacion = motivo
        venta.producto?.stock += venta.cantidad

        do {
            try contexto.save()
            cargarVentas()
        } catch {
            contexto.rollback()
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo anular la venta: \(error.localizedDescription)")
        }
    }
}

extension VentasEquipoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cargarVentas()
    }
}
