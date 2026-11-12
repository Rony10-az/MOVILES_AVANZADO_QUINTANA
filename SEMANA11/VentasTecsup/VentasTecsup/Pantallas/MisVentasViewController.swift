//
//  MisVentasViewController.swift
//  VentasTecsup
//
//  Pantalla A6: historial de ventas del vendedor conectado.
//  El vendedor solo ve sus propias ventas (predicate por vendedor).
//

import UIKit
import CoreData

class MisVentasViewController: UITableViewController {

    private var ventas: [Venta] = []
    private let buscador = UISearchController(searchResultsController: nil)
    private let segmentado = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])

    private let indicadorHoy = UILabel()
    private let indicadorMes = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis ventas"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")

        navigationItem.searchController = buscador
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"

        segmentado.selectedSegmentIndex = 0
        segmentado.addTarget(self, action: #selector(filtroCambiado), for: .valueChanged)

        let indicadores = construirIndicadores()
        let contenedor = UIStackView(arrangedSubviews: [indicadores, segmentado])
        contenedor.axis = .vertical
        contenedor.spacing = 8
        contenedor.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        contenedor.isLayoutMarginsRelativeArrangement = true
        contenedor.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 96)
        tableView.tableHeaderView = contenedor
    }

    private func construirIndicadores() -> UIStackView {
        func columna(titulo: String, label: UILabel) -> UIStackView {
            let tituloLabel = UILabel()
            tituloLabel.text = titulo
            tituloLabel.font = .systemFont(ofSize: 12)
            tituloLabel.textColor = .secondaryLabel
            label.font = .boldSystemFont(ofSize: 20)
            let col = UIStackView(arrangedSubviews: [tituloLabel, label])
            col.axis = .vertical
            return col
        }
        let fila = UIStackView(arrangedSubviews: [columna(titulo: "Hoy", label: indicadorHoy), columna(titulo: "Mes", label: indicadorMes)])
        fila.axis = .horizontal
        fila.distribution = .fillEqually
        return fila
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarVentas()
    }

    private func cargarVentas() {
        guard let vendedor = SesionUsuario.compartida.usuarioActual else { return }
        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Venta> = Venta.fetchRequest()
        solicitud.predicate = NSPredicate(format: "vendedor == %@", vendedor)
        solicitud.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]

        do {
            let todas = try contexto.fetch(solicitud)
            actualizarIndicadores(todas)
            ventas = aplicarFiltros(todas)
            tableView.reloadData()
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudieron cargar tus ventas: \(error.localizedDescription)")
        }
    }

    private func actualizarIndicadores(_ todas: [Venta]) {
        let calendario = Calendar.current
        let hoy = todas.filter { !$0.anulada && ($0.fecha.map { calendario.isDateInToday($0) } ?? false) }
        let mes = todas.filter { venta in
            guard !venta.anulada, let fecha = venta.fecha else { return false }
            return calendario.isDate(fecha, equalTo: Date(), toGranularity: .month)
        }
        indicadorHoy.text = hoy.reduce(0) { $0 + $1.total }.comoMoneda
        indicadorMes.text = mes.reduce(0) { $0 + $1.total }.comoMoneda
    }

    private func aplicarFiltros(_ todas: [Venta]) -> [Venta] {
        var resultado = todas
        let calendario = Calendar.current
        switch segmentado.selectedSegmentIndex {
        case 1:
            resultado = resultado.filter { $0.fecha.map { calendario.isDateInToday($0) } ?? false }
        case 2:
            resultado = resultado.filter { $0.fecha.map { calendario.isDate($0, equalTo: Date(), toGranularity: .month) } ?? false }
        default:
            break
        }
        if let texto = buscador.searchBar.text, !texto.isEmpty {
            resultado = resultado.filter { ($0.cliente?.nombre ?? "").localizedCaseInsensitiveContains(texto) }
        }
        return resultado
    }

    @objc private func filtroCambiado() {
        cargarVentas()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let venta = ventas[indexPath.row]
        var config = celda.defaultContentConfiguration()

        let fechaTexto = venta.fecha.map { DateFormatter.localizedString(from: $0, dateStyle: .short, timeStyle: .none) } ?? ""
        let textoBase = "\(venta.cliente?.nombre ?? "-") · \(venta.producto?.nombre ?? "-") × \(venta.cantidad)"

        if venta.anulada {
            let atribuido = NSAttributedString(string: textoBase, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            config.attributedText = atribuido
            config.secondaryText = "Anulada · \(fechaTexto)"
            config.secondaryTextProperties.color = .systemRed
        } else {
            config.text = textoBase
            config.secondaryText = "\(fechaTexto) · \(venta.total.comoMoneda)"
        }
        celda.contentConfiguration = config
        celda.selectionStyle = .none
        return celda
    }
}

extension MisVentasViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cargarVentas()
    }
}
