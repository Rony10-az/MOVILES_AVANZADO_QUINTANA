import Foundation

// ===== EJERCICIO 7: INVENTARIO CON MENÚ =====

// Arreglo para guardar los nombres de los productos.
var nombres: [String] = []

// Arreglo para guardar los precios de los productos.
var precios: [Double] = []

// Arreglo para guardar el stock de los productos.
var stocks: [Int] = []

// Pedimos la cantidad de productos.
print("¿Cuántos productos desea registrar?")

// Leemos la cantidad de productos.
let cantidad = Int(readLine() ?? "") ?? 0

// Repetimos el proceso para cada producto.
for i in 1...cantidad {
    
    // Pedimos el nombre del producto.
    print("\nNombre del producto \(i):")
    
    // Guardamos el nombre ingresado.
    let nombre = readLine() ?? ""
    
    // Pedimos el precio del producto.
    print("Precio del producto \(i):")
    
    // Convertimos el precio ingresado a Double.
    let precio = Double(readLine() ?? "") ?? 0.0
    
    // Pedimos el stock del producto.
    print("Stock del producto \(i):")
    
    // Convertimos el stock ingresado a Int.
    let stock = Int(readLine() ?? "") ?? 0
    
    // Agregamos el nombre al arreglo.
    nombres.append(nombre)
    
    // Agregamos el precio al arreglo.
    precios.append(precio)
    
    // Agregamos el stock al arreglo.
    stocks.append(stock)
}

// Variable para controlar el menú.
var opcion = 0

// Repetimos el menú hasta elegir la opción 5.
while opcion != 5 {
    
    // Mostramos el menú.
    print("""
    
    ===== MENÚ DE INVENTARIO =====
    1. Ver inventario
    2. Buscar producto
    3. Stock bajo
    4. Valor total
    5. Salir
    ==============================
    """)
    
    // Pedimos una opción.
    print("Seleccione una opción:")
    
    // Leemos la opción.
    opcion = Int(readLine() ?? "") ?? 0
    
    // Evaluamos la opción seleccionada.
    switch opcion {
        
    // ===== OPCIÓN 1: VER INVENTARIO =====
    case 1:
        
        // Mostramos el título.
        print("\n===== INVENTARIO =====")
        
        // Recorremos todos los productos.
        for i in 0..<nombres.count {
            
            // Mostramos los datos del producto.
            print("Producto: \(nombres[i]) | Precio: S/ \(String(format: "%.2f", precios[i])) | Stock: \(stocks[i])")
        }
        
    // ===== OPCIÓN 2: BUSCAR PRODUCTO =====
    case 2:
        
        // Pedimos el producto que se desea buscar.
        print("\nIngrese el nombre del producto:")
        
        // Guardamos el nombre buscado.
        let busqueda = readLine() ?? ""
        
        // Variable para saber si encontramos el producto.
        var encontrado = false
        
        // Recorremos todos los productos.
        for i in 0..<nombres.count {
            
            // Comparamos los nombres sin importar mayúsculas o minúsculas.
            if nombres[i].lowercased() == busqueda.lowercased() {
                
                // Mostramos los datos del producto encontrado.
                print("Producto encontrado:")
                print("Nombre: \(nombres[i])")
                print("Precio: S/ \(String(format: "%.2f", precios[i]))")
                print("Stock: \(stocks[i])")
                
                // Indicamos que el producto fue encontrado.
                encontrado = true
            }
        }
        
        // Si no encontramos el producto.
        if !encontrado {
            
            // Mostramos un mensaje.
            print("Producto no encontrado.")
        }
        
    // ===== OPCIÓN 3: STOCK BAJO =====
    case 3:
        
        // Definimos el límite para considerar stock bajo.
        let limiteStock = 5
        
        // Mostramos el título.
        print("\n===== STOCK BAJO =====")
        
        // Recorremos todos los productos.
        for i in 0..<nombres.count {
            
            // Comprobamos si el stock es menor o igual a 5.
            if stocks[i] <= limiteStock {
                
                // Mostramos el producto con stock bajo.
                print("Producto: \(nombres[i]) | Stock: \(stocks[i])")
            }
        }
        
    // ===== OPCIÓN 4: VALOR TOTAL =====
    case 4:
        
        // Variable para almacenar el valor total.
        var valorTotal = 0.0
        
        // Recorremos todos los productos.
        for i in 0..<nombres.count {
            
            // Calculamos el valor de cada producto.
            valorTotal += precios[i] * Double(stocks[i])
        }
        
        // Mostramos el título.
        print("\n===== VALOR TOTAL =====")
        
        // Mostramos el valor total del inventario.
        print("Valor total: S/ \(String(format: "%.2f", valorTotal))")
        
    // ===== OPCIÓN 5: SALIR =====
    case 5:
        
        // Mostramos mensaje de salida.
        print("\nPrograma finalizado.")
        
    // ===== OPCIÓN NO VÁLIDA =====
    default:
        
        // Mostramos mensaje de error.
        print("\nOpción no válida.")
    }
}
