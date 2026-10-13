//
//  ViewController.swift
//  Sem07_CulturasPeruanas
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCulturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //crear un objeto para que se muestre la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda") as! CulturaTableViewCell
        cell.nombreCultura.text = listaCulturas[indexPath.row].nombre
        cell.fotoCultura.image = listaCulturas[indexPath.row].imagen
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        culturaSeleccionada = listaCulturas[indexPath.row]
        performSegue(withIdentifier: "irADetalle", sender: self)
    }

    // Lista de Culturas Peruanas

    var listaCulturas = [
        Cultura(nombre: "Cultura Chavín", region: "Áncash", descripcion: "Una de las civilizaciones más antiguas del Perú, conocida por su arquitectura monumental y arte religioso.", imagen: UIImage(named: "chavin")),
        Cultura(nombre: "Cultura Nazca", region: "Ica", descripcion: "Famosa por las Líneas de Nazca, enormes geoglifos trazados en el desierto.", imagen: UIImage(named: "nazca")),
        Cultura(nombre: "Cultura Moche", region: "La Libertad", descripcion: "Destacó por su cerámica realista y las Huacas del Sol y de la Luna.", imagen: UIImage(named: "moche")),
        Cultura(nombre: "Cultura Chimú", region: "La Libertad", descripcion: "Constructores de Chan Chan, la ciudad de barro más grande de América.", imagen: UIImage(named: "chimu")),
        Cultura(nombre: "Cultura Inca", region: "Cusco", descripcion: "El imperio más grande de la América precolombina, creadores de Machu Picchu.", imagen: UIImage(named: "inca"))
    ]
    //Metodos del data source

    var culturaSeleccionada: Cultura!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irADetalle" {
            let detalleVC = segue.destination as! DetalleViewController
            detalleVC.cultura = culturaSeleccionada
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
