//
//  SelectorListaViewController.swift
//  VentasTecsup
//
//  Lista reutilizable para elegir un Cliente o un Producto desde
//  Nueva venta, con búsqueda por el texto visible de cada fila.
//

import UIKit
import CoreData

struct ItemSeleccionable {
    let objectID: NSManagedObjectID
    let titulo: String
    let subtitulo: String
}

class SelectorListaViewController: UITableViewController {

    private let items: [ItemSeleccionable]
    private var filtrados: [ItemSeleccionable]
    private let onSeleccion: (NSManagedObjectID) -> Void
    private let buscador = UISearchController(searchResultsController: nil)

    init(titulo: String, items: [ItemSeleccionable], onSeleccion: @escaping (NSManagedObjectID) -> Void) {
        self.items = items
        self.filtrados = items
        self.onSeleccion = onSeleccion
        super.init(style: .plain)
        self.title = titulo
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementado") }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtrados.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let item = filtrados[indexPath.row]
        var config = celda.defaultContentConfiguration()
        config.text = item.titulo
        config.secondaryText = item.subtitulo
        celda.contentConfiguration = config
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filtrados[indexPath.row]
        onSeleccion(item.objectID)
        navigationController?.popViewController(animated: true)
    }
}

extension SelectorListaViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let texto = searchController.searchBar.text ?? ""
        filtrados = texto.isEmpty ? items : items.filter {
            $0.titulo.localizedCaseInsensitiveContains(texto) || $0.subtitulo.localizedCaseInsensitiveContains(texto)
        }
        tableView.reloadData()
    }
}
