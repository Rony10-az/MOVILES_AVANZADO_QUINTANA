//
//  ClientesViewController.swift
//  VentasTecsup
//
//  Pantalla A4: clientes con categoría y total comprado calculados.
//  Ambos roles crean/editan; solo Supervisor borra.
//

import UIKit
import CoreData

class ClientesViewController: UITableViewController {

    private var clientes: [Cliente] = []
    private let buscador = UISearchController(searchResultsController: nil)

    private var esSupervisor: Bool {
        SesionUsuario.compartida.rolActual == .supervisor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celda")

        navigationItem.searchController = buscador
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre o documento"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(agregarTocado))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarClientes()
    }

    private func cargarClientes() {
        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do {
            var todos = try contexto.fetch(solicitud)
            if let texto = buscador.searchBar.text, !texto.isEmpty {
                todos = todos.filter {
                    ($0.nombre ?? "").localizedCaseInsensitiveContains(texto) ||
                    ($0.documento ?? "").localizedCaseInsensitiveContains(texto)
                }
            }
            clientes = todos
            tableView.reloadData()
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudieron cargar los clientes: \(error.localizedDescription)")
        }
    }

    @objc private func agregarTocado() {
        presentarFormulario(cliente: nil)
    }

    private func presentarFormulario(cliente: Cliente?) {
        let esNuevo = cliente == nil
        let alerta = UIAlertController(title: esNuevo ? "Nuevo cliente" : "Editar cliente", message: nil, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = cliente?.nombre }
        alerta.addTextField { $0.placeholder = "Documento (RUC/DNI)"; $0.text = cliente?.documento }

        let guardar = UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            guard let self, let campos = alerta?.textFields else { return }
            let nombre = (campos[0].text ?? "").trimmingCharacters(in: .whitespaces)
            let documento = (campos[1].text ?? "").trimmingCharacters(in: .whitespaces)

            guard !nombre.isEmpty, !documento.isEmpty else {
                self.mostrarAlerta(titulo: "Datos inválidos", mensaje: "Completa nombre y documento.")
                return
            }

            let contexto = SesionUsuario.compartida.contexto
            let objetivo = cliente ?? Cliente(context: contexto)
            objetivo.nombre = nombre
            objetivo.documento = documento

            do {
                try contexto.save()
                self.cargarClientes()
            } catch {
                self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo guardar: \(error.localizedDescription)")
            }
        }
        alerta.addAction(guardar)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alerta, animated: true)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let cliente = clientes[indexPath.row]
        var config = celda.defaultContentConfiguration()
        config.text = cliente.nombre
        config.secondaryText = "\(cliente.documento ?? "") · \(cliente.totalComprado.comoMoneda) comprado"
        config.image = imagenAvatar(nombre: cliente.nombre ?? "?")
        config.imageProperties.maximumSize = CGSize(width: 36, height: 36)
        config.imageProperties.cornerRadius = 18
        celda.contentConfiguration = config
        let insignia = InsigniaLabel(texto: cliente.categoria.rawValue, color: colorCategoria(cliente.categoria))
        insignia.frame.size = insignia.intrinsicContentSize
        celda.accessoryView = insignia
        return celda
    }

    private func colorCategoria(_ categoria: CategoriaCliente) -> UIColor {
        switch categoria {
        case .vip: return .systemPurple
        case .frecuente: return .tecsupAzul
        case .regular: return .systemGray
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentarFormulario(cliente: clientes[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        esSupervisor
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let cliente = clientes[indexPath.row]
        let contexto = SesionUsuario.compartida.contexto
        contexto.delete(cliente)
        do {
            try contexto.save()
            cargarClientes()
        } catch {
            contexto.rollback()
            mostrarAlerta(titulo: "No se puede borrar", mensaje: "Este cliente tiene ventas registradas y no puede eliminarse.")
        }
    }
}

extension ClientesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cargarClientes()
    }
}
