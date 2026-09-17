//Caso 1.5 : Herencia y polimorfismo

enum CategoriaElectro {
    case lineablanca, tecnologia , pequenos
}

struct Electrodomestico{
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

// --Ejemplo : La base define el FLUJO; las hijas cambiara las REGLAS

class Sucursal {
    let nombre: String
    let ciudad: String
    
    init(nombre:String, ciudad:String){
        self.nombre = nombre
        self.ciudad = ciudad
    }
    func descuento() -> Double {
        return 0.05
    }
    func costoEnvio(monto: Double) -> Double{
        return 30.0
    }
    
    //Regla 2 : este metodo NO se sobreescribe en las subclases
    func cotizar(item: Electrodomestico){
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/. \(precioConDescuento) + envio S/. \(envio) = S/. \(total)")
    }
}

// TODO 14 : SucursalLima

class SucursalLima: Sucursal {
    
    override func descuento() -> Double {
        return 0.1
    }
    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500 {
            return 0.0
        }else {
            return 30.0
        }
    }
}

// --TODO 15 : SucursalProvincia

class SucursalProvincia : Sucursal{
    
    // No se sobreescribe descuento() -> hereda el 5% de Sucursal
    
    override func costoEnvio(monto: Double) -> Double {
        let envio = monto * 0.08
        if envio < 50.0 {
            return 50.0
        } else{
            return envio
        }
    }
}

// TODO 16 : SucuralOutlet

class SucursalOutlet : Sucursal{
    
    override func descuento() -> Double {
        return 0.25
    }
    
    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}


//TODO 18: La prueba del polimorfismo

class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let envio = 15.0
        return envio
    }
}
// ======== FIX : Este codigo tiene 2 errores=======

class SucursalMall: Sucursal {
    
    override func descuento() -> Double { // El override
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Int
    init(nombre: String, ciudad: String, radioKm: Int){
        self.radioKm = radioKm
        
        super.init(nombre: nombre, ciudad: ciudad) // El superinit los atributos heredan de sucursal clase padre
    }
}

let misteriosa: Sucursal = SucursalLima(nombre: "lima Centro", ciudad: "lima")

let refrifedora = Electrodomestico(nombre: "Refrigedora", marca:"Frost", precioLista: 2000.0, categoria: .lineablanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima"),
    SucursalOnline(nombre: "Tecsup Santa anita", ciudad: "Lima")]



print("\n====== Refrigeradora {S/ 2000.0} =====")
for sucursal in sucursales {sucursal.cotizar(item: refrifedora)}
print("\n===== Licuadora {S/ 250.0} ======")
for sucursal in sucursales {sucursal.cotizar(item: licuadora)}

print("\n===== PREDICT ======")
print("El descuento es: \(misteriosa.descuento()) ") // hereda de sucursallima -> 0.1

let monto = 2000.0 * (1 - misteriosa.descuento()) // monto = 1800 -> en sucursalLima el monto >= 1500 por lo tanto es 0.0 el envio
print("El costo de envio: \(misteriosa.costoEnvio(monto: monto))")


