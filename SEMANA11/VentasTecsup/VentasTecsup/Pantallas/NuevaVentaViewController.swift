//
//  NuevaVentaViewController.swift
//  VentasTecsup
//
//  Pantalla A5: registrar una venta. Calcula subtotal, descuento,
//  IGV y total; valida el stock disponible antes de guardar.
//  Tabla y celdas (celdaVenta, celdaCantidadVenta) definidas en Main.storyboard.
//

import UIKit
import CoreData

class NuevaVentaViewController: UIViewController {

    @IBOutlet private weak var tablaNuevaVenta: UITableView!

    private enum Seccion: Int, CaseIterable {
        case vendedor, cliente, producto, cantidad, resumen, accion
    }

    private var clienteElegido: Cliente?
    private var productoElegido: Producto?
    private var cantidad: Int = 1
    private var cantidadMaxima: Double = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva venta"
        tablaNuevaVenta.dataSource = self
        tablaNuevaVenta.delegate = self
        // Espacio extra para que "Registrar venta" no quede bajo el tab bar flotante.
        tablaNuevaVenta.contentInset.bottom = 90
    }

    // MARK: - Selección de cliente / producto

    private func elegirCliente() {
        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        guard let clientes = try? contexto.fetch(solicitud) else { return }
        let items = clientes.map { ItemSeleccionable(objectID: $0.objectID, titulo: $0.nombre ?? "", subtitulo: $0.categoria.rawValue) }
        let selector: SelectorListaViewController = Pantalla.instanciar("SelectorLista")
        selector.configurar(titulo: "Elegir cliente", items: items) { [weak self] id in
            guard let self else { return }
            self.clienteElegido = try? contexto.existingObject(with: id) as? Cliente
            self.tablaNuevaVenta.reloadData()
        }
        navigationController?.pushViewController(selector, animated: true)
    }

    private func elegirProducto() {
        let contexto = SesionUsuario.compartida.contexto
        let solicitud: NSFetchRequest<Producto> = Producto.fetchRequest()
        solicitud.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        guard let productos = try? contexto.fetch(solicitud) else { return }
        let items = productos.map { ItemSeleccionable(objectID: $0.objectID, titulo: $0.nombre ?? "", subtitulo: "Stock \($0.stock) · \($0.precio.comoMoneda)") }
        let selector: SelectorListaViewController = Pantalla.instanciar("SelectorLista")
        selector.configurar(titulo: "Elegir producto", items: items) { [weak self] id in
            guard let self else { return }
            self.productoElegido = try? contexto.existingObject(with: id) as? Producto
            self.cantidad = 1
            self.cantidadMaxima = max(1, Double(self.productoElegido?.stock ?? 1))
            self.tablaNuevaVenta.reloadData()
        }
        navigationController?.pushViewController(selector, animated: true)
    }

    @objc private func cantidadCambiada(_ sender: UIStepper) {
        cantidad = Int(sender.value)
        tablaNuevaVenta.reloadSections(IndexSet([Seccion.cantidad.rawValue, Seccion.resumen.rawValue]), with: .none)
    }

    // MARK: - Cálculo y registro

    private func calcularResumen() -> (subtotal: Double, descuento: Double, igv: Double, total: Double) {
        guard let producto = productoElegido else { return (0, 0, 0, 0) }
        let categoria = clienteElegido?.categoria ?? .regular
        return ReglasVenta.calcular(cantidad: cantidad, precioUnitario: producto.precio, categoria: categoria)
    }

    private func registrarVentaTocado() {
        guard let cliente = clienteElegido else {
            return mostrarAlerta(titulo: "Falta el cliente", mensaje: "Elige un cliente para la venta.")
        }
        guard let producto = productoElegido else {
            return mostrarAlerta(titulo: "Falta el producto", mensaje: "Elige un producto para la venta.")
        }
        guard let vendedor = SesionUsuario.compartida.usuarioActual else { return }

        guard cantidad <= producto.stock else {
            return mostrarAlerta(titulo: "Stock insuficiente", mensaje: "Solo hay \(producto.stock) unidades disponibles de \(producto.nombre ?? "este producto").")
        }

        let resumen = calcularResumen()
        let contexto = SesionUsuario.compartida.contexto
        let venta = Venta(context: contexto)
        venta.fecha = Date()
        venta.cantidad = Int32(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = resumen.descuento
        venta.igv = resumen.igv
        venta.total = resumen.total
        venta.anulada = false
        venta.cliente = cliente
        venta.producto = producto
        venta.vendedor = vendedor

        producto.stock -= Int32(cantidad)

        do {
            try contexto.save()
            mostrarAlerta(titulo: "Venta registrada", mensaje: "Total: \(resumen.total.comoMoneda)")
            limpiarFormulario()
        } catch {
            contexto.rollback()
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo registrar la venta: \(error.localizedDescription)")
        }
    }

    private func limpiarFormulario() {
        clienteElegido = nil
        productoElegido = nil
        cantidad = 1
        cantidadMaxima = 1
        tablaNuevaVenta.reloadData()
    }
}

extension NuevaVentaViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { Seccion.allCases.count }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Seccion(rawValue: section)! {
        case .vendedor: return "Vendedor"
        case .cliente: return "Cliente"
        case .producto: return "Producto"
        case .cantidad: return "Cantidad"
        case .resumen: return "Resumen (calculado)"
        case .accion: return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Seccion(rawValue: section)! {
        case .resumen: return 4
        default: return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Seccion(rawValue: indexPath.section)! == .cantidad {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaCantidadVenta", for: indexPath) as! CeldaCantidadVenta
            celda.valorLabel.text = "\(cantidad)"
            celda.stepper.minimumValue = 1
            celda.stepper.maximumValue = cantidadMaxima
            celda.stepper.value = Double(cantidad)
            celda.stepper.removeTarget(nil, action: nil, for: .valueChanged)
            celda.stepper.addTarget(self, action: #selector(cantidadCambiada(_:)), for: .valueChanged)
            return celda
        }

        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaVenta", for: indexPath)
        celda.selectionStyle = .none
        celda.accessoryView = nil
        celda.accessoryType = .none

        switch Seccion(rawValue: indexPath.section)! {
        case .vendedor:
            var config = celda.defaultContentConfiguration()
            config.text = SesionUsuario.compartida.usuarioActual?.nombre ?? "-"
            config.secondaryText = "Sesión iniciada · no editable"
            celda.contentConfiguration = config

        case .cliente:
            var config = celda.defaultContentConfiguration()
            config.text = clienteElegido?.nombre ?? "Toca para elegir"
            config.secondaryText = clienteElegido.map { "\($0.categoria.rawValue) · \($0.totalComprado.comoMoneda) comprado" }
            celda.contentConfiguration = config
            celda.accessoryType = .disclosureIndicator
            celda.selectionStyle = .default

        case .producto:
            var config = celda.defaultContentConfiguration()
            config.text = productoElegido?.nombre ?? "Toca para elegir"
            config.secondaryText = productoElegido.map { "\($0.precio.comoMoneda) · stock \($0.stock)" }
            celda.contentConfiguration = config
            celda.accessoryType = .disclosureIndicator
            celda.selectionStyle = .default

        case .resumen:
            let resumen = calcularResumen()
            let filas: [(String, Double)] = [
                ("Subtotal", resumen.subtotal),
                ("Descuento", resumen.descuento),
                ("IGV (18%)", resumen.igv),
                ("Total", resumen.total)
            ]
            let fila = filas[indexPath.row]
            var config = celda.defaultContentConfiguration()
            config.text = fila.0
            config.secondaryText = fila.1.comoMoneda
            if fila.0 == "Total" {
                config.textProperties.font = .boldSystemFont(ofSize: 17)
            }
            celda.contentConfiguration = config

        case .accion:
            var config = celda.defaultContentConfiguration()
            config.text = "Registrar venta"
            config.textProperties.color = .tecsupAzul
            config.textProperties.alignment = .center
            celda.contentConfiguration = config
            celda.selectionStyle = .default

        case .cantidad:
            break
        }
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Seccion(rawValue: indexPath.section)! {
        case .cliente: elegirCliente()
        case .producto: elegirProducto()
        case .accion: registrarVentaTocado()
        default: break
        }
    }
}
