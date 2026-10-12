//
//  ViewController.swift
//  Calculadora_Prestamos
//
//  Created by Rony Quintana on 4/10/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var capitalTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var yearsTextField: UITextField!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyLabel.text = "Ingresa los datos y pulsa Calcular"
        totalLabel.text = ""
    }

    @IBAction func calcularPrestamo(_ sender: UIButton) {
        // Datos de entrada: capital, tasa anual (%) y plazo en años
        guard let capital = Double(capitalTextField.text ?? ""), capital > 0,
              let tasaAnual = Double(rateTextField.text ?? ""), tasaAnual >= 0,
              let years = Int(yearsTextField.text ?? ""), years > 0 else {
            monthlyLabel.text = "Por favor, ingresa valores válidos."
            totalLabel.text = ""
            return
        }

        // r = tasa mensual (interés anual / 12), n = número total de cuotas
        let r = tasaAnual / 100 / 12
        let n = Double(years * 12)

        // Fórmula de amortización: M = P · r(1+r)^n / ((1+r)^n − 1)
        let cuota: Double
        if r == 0 {
            cuota = capital / n
        } else {
            let factor = pow(1 + r, n)
            cuota = capital * r * factor / (factor - 1)
        }

        // Monto total a pagar = cuota mensual × número de pagos
        let total = cuota * n

        monthlyLabel.text = String(format: "Cuota mensual: %.2f", cuota)
        totalLabel.text = String(format: "Monto total a pagar: %.2f", total)
    }
}
