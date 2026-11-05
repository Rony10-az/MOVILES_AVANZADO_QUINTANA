//
//  ViewController.swift
//  Apple_lab11_01_UIKIT_CoreData
//
//  Created by Rony Jhostin on 5/11/26.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = TablaContacto.dequeueReusableCell(withIdentifier: "Contactos", for: indexPath)
        celda.textLabel?.text = contactos[indexPath.row].nombre
        celda.detailTextLabel?.text = "\(contactos[indexPath.row].telefono ?? "") | \(contactos[indexPath.row].direccion ?? "")"
        return celda
    }
    
    @IBOutlet weak var TablaContacto: UITableView!
    
    //Arreglo que almacena los contactos obtenidos desde core data
    
    var contactos = [Contacto]()
    //Metodo llamado al cargar la vista
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TablaContacto.dataSource = self
        TablaContacto.delegate = self
        mostrarRutaBaseDeDatos()
        cargarInfoCoreData()
    }


    
    // MARK : - Conexion con core Data
    
    // Obtiene el contexto de Core Data para realizar operaciones de lectura y escritura
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    func mostrarRutaBaseDeDatos(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let ruta = delegate.persistentContainer.persistentStoreDescriptions.first?.url?.path ?? "Sin ruta"
        print("Base de datos SQLITE en : \(ruta) ")
    }
    
    // MARK - READ : leer los datos
    
    //Carga los contactos almacenados y actualiza el arreglo local
    func cargarInfoCoreData(){
        let contexto = conexion()
        let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        //Orden alfabetico por nombre
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch {
            print("Error al cargar la BD : \(error)")
        }
    }
    
    // MARK : - CREATE : agregar un contacto
    
    // Accion vinculada al button Item (+)
    

    @IBAction func AgregarContacto(_ sender: Any) {
        let alert = UIAlertController(title: "Agregar Contacto", message: "Nuevo Contacto", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Nombre" }
        alert.addTextField { $0.placeholder = "Telefono" }
        alert.addTextField { $0.placeholder = "Direccion" }
        
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default){
            _ in guard let nombre  = alert.textFields?[0].text, !nombre.isEmpty else {return}
            let telefono = alert.textFields?[1].text ?? ""
            let direccion = alert.textFields?[2].text ?? ""
            
            let contexto = self.conexion()
            //Crea un nuevo objeto Contacto en el contexto (Todavia no esta guardado)
            let entidad = NSEntityDescription.insertNewObject(forEntityName: "Contacto", into: contexto) as! Contacto
            entidad.nombre = nombre
            entidad.telefono = telefono
            entidad.direccion = direccion
            
            do{
                try contexto.save()  //Aqui se escribe en el archivo SQLite
                self.cargarInfoCoreData() // Vuelve a leer los datos
                self.TablaContacto.reloadData()
            } catch {
                print("Error al guardar el dato : \(error)")
            }
        }
        alert.addAction(actionAceptar)
        alert.addAction(UIAlertAction(title:"Cancelar", style: .cancel))
        present(alert, animated:true)

    }

    // MARK : - UPDATE : editar un contacto (al tocar una fila)

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contacto = contactos[indexPath.row]

        let alert = UIAlertController(title: "Editar Contacto", message: "Modifica los datos", preferredStyle: .alert)
        alert.addTextField { $0.text = contacto.nombre }
        alert.addTextField { $0.text = contacto.telefono }
        alert.addTextField { $0.text = contacto.direccion }

        let actionGuardar = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let nombre = alert.textFields?[0].text, !nombre.isEmpty else { return }
            // Cambiar las propiedades del objeto y guardar el contexto
            contacto.nombre = nombre
            contacto.telefono = alert.textFields?[1].text
            contacto.direccion = alert.textFields?[2].text
            do {
                try self.conexion().save()
                self.cargarInfoCoreData()
                self.TablaContacto.reloadData()
            } catch {
                print("Error al actualizar : \(error)")
            }
        }
        alert.addAction(actionGuardar)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    // MARK : - DELETE : eliminar un contacto

    // Elimina un contacto especifico dado el indice en la tabla
    func eliminarContacto(at indexPath: IndexPath) {
        let contexto = conexion()
        let contactoEliminar = contactos[indexPath.row]
        contexto.delete(contactoEliminar)      // Marca el objeto para borrarlo
        do {
            try contexto.save()                // Confirma el borrado en SQLite
            contactos.remove(at: indexPath.row) // Lo quita del arreglo local
            TablaContacto.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error al eliminar : \(error)")
        }
    }

    // Permite eliminar deslizando la fila hacia la izquierda
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            eliminarContacto(at: indexPath)
        }
    }
}

