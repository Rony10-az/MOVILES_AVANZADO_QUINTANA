//
//  ViewController.swift
//  Lab06-Calculadora
//
//  Created by Rony Jhostin on 12/10/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfElectrodomestico: UITextField!
    @IBOutlet weak var tfPrecioUnitario: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfMeses: UITextField!
    @IBOutlet weak var tfInteres: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            if let destino = segue.destination as? ViewControllerResultado {
                let precioUnitario = Double(tfPrecioUnitario.text ?? "") ?? 0
                let cantidad = Double(tfCantidad.text ?? "") ?? 0
                let meses = Double(tfMeses.text ?? "") ?? 0
                let tasaInteresMensual = Double(tfInteres.text ?? "") ?? 0

                let subtotal = precioUnitario * cantidad
                let igv = subtotal * 0.18
                let base = subtotal + igv
                let intereses = base * (tasaInteresMensual / 100) * meses
                let total = base + intereses
                let cuota = meses > 0 ? total / meses : 0

                let oVenta = VentaModel(pSubtotal: subtotal, pIgv: igv, pBase: base, pIntereses: intereses, pTotal: total, pCuota: cuota)
                destino.pVenta = oVenta
            }
        }
    }
}
