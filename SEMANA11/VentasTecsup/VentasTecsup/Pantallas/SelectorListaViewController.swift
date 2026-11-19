//
//  SelectorListaViewController.swift
//  VentasTecsup
//
//  Lista reutilizable para elegir un Cliente o un Producto desde
//  Nueva venta, con búsqueda por el texto visible de cada fila.
//  Tabla e identificador de celda definidos en Main.storyboard.
//

import UIKit
import CoreData

struct ItemSeleccionable {
    let objectID: NSManagedObjectID
    let titulo: String
    let subtitulo: String
}

class SelectorListaViewController: UIViewController {

    @IBOutlet private weak var tablaSelector: UITableView!

    private var items: [ItemSeleccionable] = []
    private var filtrados: [ItemSeleccionable] = []
    private var onSeleccion: ((NSManagedObjectID) -> Void)?
    private let buscador = UISearchController(searchResultsController: nil)

    /// Debe llamarse justo después de instanciar la pantalla desde el storyboard y antes de mostrarla.
    func configurar(titulo: String, items: [ItemSeleccionable], onSeleccion: @escaping (NSManagedObjectID) -> Void) {
        self.title = titulo
        self.items = items
        self.filtrados = items
        self.onSeleccion = onSeleccion
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSelector.dataSource = self
        tablaSelector.delegate = self
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
    }
}

extension SelectorListaViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtrados.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaSelector", for: indexPath)
        let item = filtrados[indexPath.row]
        var config = celda.defaultContentConfiguration()
        config.text = item.titulo
        config.secondaryText = item.subtitulo
        celda.contentConfiguration = config
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filtrados[indexPath.row]
        onSeleccion?(item.objectID)
        navigationController?.popViewController(animated: true)
    }
}

extension SelectorListaViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let texto = searchController.searchBar.text ?? ""
        filtrados = texto.isEmpty ? items : items.filter {
            $0.titulo.localizedCaseInsensitiveContains(texto) || $0.subtitulo.localizedCaseInsensitiveContains(texto)
        }
        tablaSelector.reloadData()
    }
}
