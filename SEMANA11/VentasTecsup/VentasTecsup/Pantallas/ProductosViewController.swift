//
//  ProductosViewController.swift
//  VentasTecsup
//
//  Pantalla A3: listado de productos con búsqueda, chips de categoría
//  y color según stock. Supervisor crea/edita/borra; Vendedor solo consulta.
//

import UIKit
import CoreData

class ProductosViewController: UITableViewController {

    private var productos: [Producto] = []
    private var categorias: [String] = ["Todos"]
    private let buscador = UISearchController(searchResultsController: nil)
    private var categoriaControl: UISegmentedControl!

    private var esSupervisor: Bool {
        SesionUsuario.compartida.rolActual == .supervisor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")

        navigationItem.searchController = buscador
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar producto"

        if esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(agregarTocado))
        }

        categoriaControl = UISegmentedControl(items: categorias)
        categoriaControl.selectedSegmentIndex = 0
        categoriaControl.addTarget(self, action: #selector(categoriaCambiada), for: .valueChanged)
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44))
        categoriaControl.frame = contenedor.bounds.insetBy(dx: 12, dy: 4)
        categoriaControl.autoresizingMask = [.flexibleWidth]
        contenedor.addSubview(categoriaControl)
        tableView.tableHeaderView = contenedor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarProductos()
    }

    private func cargarProductos() {
        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Producto> = Producto.fetchRequest()
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do {
            let todos = try contexto.fetch(solicitud)
            actualizarCategorias(con: todos)
            productos = filtrar(todos)
            tableView.reloadData()
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudieron cargar los productos: \(error.localizedDescription)")
        }
    }

    private func actualizarCategorias(con lista: [Producto]) {
        let nuevas = ["Todos"] + Array(Set(lista.compactMap { $0.categoria })).sorted()
        if nuevas != categorias {
            categorias = nuevas
            categoriaControl.removeAllSegments()
            for (i, nombre) in categorias.enumerated() {
                categoriaControl.insertSegment(withTitle: nombre, at: i, animated: false)
            }
            categoriaControl.selectedSegmentIndex = 0
        }
    }

    private func filtrar(_ lista: [Producto]) -> [Producto] {
        var resultado = lista
        if categoriaControl.selectedSegmentIndex > 0 {
            let categoriaElegida = categorias[categoriaControl.selectedSegmentIndex]
            resultado = resultado.filter { $0.categoria == categoriaElegida }
        }
        if let texto = buscador.searchBar.text, !texto.isEmpty {
            resultado = resultado.filter { ($0.nombre ?? "").localizedCaseInsensitiveContains(texto) }
        }
        return resultado
    }

    @objc private func categoriaCambiada() {
        cargarProductos()
    }

    @objc private func agregarTocado() {
        presentarFormulario(producto: nil)
    }

    private func presentarFormulario(producto: Producto?) {
        let esNuevo = producto == nil
        let alerta = UIAlertController(title: esNuevo ? "Nuevo producto" : "Editar producto", message: nil, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = producto?.nombre }
        alerta.addTextField { $0.placeholder = "Categoría"; $0.text = producto?.categoria }
        alerta.addTextField { $0.placeholder = "Precio"; $0.text = producto.map { String($0.precio) }; $0.keyboardType = .decimalPad }
        alerta.addTextField { $0.placeholder = "Stock"; $0.text = producto.map { String($0.stock) }; $0.keyboardType = .numberPad }

        let guardar = UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            guard let self, let campos = alerta?.textFields else { return }
            let nombre = campos[0].text ?? ""
            let categoria = campos[1].text ?? ""
            let precio = Double(campos[2].text?.replacingOccurrences(of: ",", with: ".") ?? "") ?? -1
            let stock = Int32(campos[3].text ?? "") ?? -1

            guard !nombre.isEmpty, !categoria.isEmpty, precio >= 0, stock >= 0 else {
                self.mostrarAlerta(titulo: "Datos inválidos", mensaje: "Completa nombre, categoría, un precio y un stock válidos.")
                return
            }

            let contexto = SesionUsuario.compartida.contexto
            let objetivo = producto ?? Producto(context: contexto)
            objetivo.nombre = nombre
            objetivo.categoria = categoria
            objetivo.precio = precio
            objetivo.stock = stock

            do {
                try contexto.save()
                self.cargarProductos()
            } catch {
                self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo guardar: \(error.localizedDescription)")
            }
        }
        alerta.addAction(guardar)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alerta, animated: true)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let producto = productos[indexPath.row]
        var config = celda.defaultContentConfiguration()
        config.text = producto.nombre
        config.secondaryText = "\(producto.categoria ?? "") · \(producto.precio.comoMoneda) · Stock \(producto.stock)"
        celda.contentConfiguration = config
        celda.accessoryView = indicadorStock(producto.stock)
        return celda
    }

    private func indicadorStock(_ stock: Int32) -> UIView {
        let color: UIColor = stock > 10 ? .tecsupVerde : (stock >= 6 ? .tecsupAmbar : .tecsupRojo)
        let punto = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        punto.backgroundColor = color
        punto.layer.cornerRadius = 7
        return punto
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard esSupervisor else { return }
        presentarFormulario(producto: productos[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        esSupervisor
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let producto = productos[indexPath.row]
        let contexto = SesionUsuario.compartida.contexto
        contexto.delete(producto)
        do {
            try contexto.save()
            cargarProductos()
        } catch {
            contexto.rollback()
            mostrarAlerta(titulo: "No se puede borrar", mensaje: "Este producto tiene ventas registradas y no puede eliminarse.")
        }
    }
}

extension ProductosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cargarProductos()
    }
}
