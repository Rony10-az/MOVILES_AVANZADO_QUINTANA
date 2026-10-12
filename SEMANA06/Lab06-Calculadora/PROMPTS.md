# PROMPTS.md — Ejercicio 4: Calculadora de Venta a Plazos de Electrodoméstico

Rama: `ai-assisted`
Formato: Contexto → Tarea → Restricciones → Formato → Ejemplo

## Contexto

Proyecto UIKit en Swift (Xcode, sin SwiftUI) con `UINavigationController` como vista inicial.
Ya existe el patrón de los ejercicios anteriores (Lab06-Segue): una pantalla "Nueva Venta" con
campos de entrada y un botón, y una pantalla "Resultado" que recibe datos mediante un segue
`Show` y el método `prepare(for:sender:)`, usando un modelo propio (`class ... : NSObject`)
en vez de pasar variables sueltas — igual que se hizo con `ClienteModel` en el Ejercicio 2.

La pantalla "Nueva Venta" tiene 5 `UITextField` (Electrodoméstico, Precio unitario, Cantidad,
Meses, Interés mensual %) y un botón "Calcular". La pantalla "Resultado" debe mostrar 6 valores
calculados.

## Tarea

1. Define `class VentaModel: NSObject` con propiedades para las 6 salidas del cálculo
   (`subtotal`, `igv`, `base`, `intereses`, `total`, `cuota`), todas `Double`.
2. En la pantalla "Nueva Venta", implementa el cálculo completo con las fórmulas:
   ```
   subtotal  = precioUnitario * cantidad
   igv       = subtotal * 0.18
   base      = subtotal + igv
   intereses = base * (tasaInteresMensual / 100) * meses
   total     = base + intereses
   cuota     = total / meses
   ```
   y arma un `VentaModel` con los resultados.
3. Pasa el `VentaModel` a la pantalla "Resultado" con `prepare(for:sender:)`, igual que en
   el Ejercicio 2.
4. En "Resultado", muestra cada valor formateado como soles:
   `String(format: "S/. %.2f", valor)`.

## Restricciones (CTRFE)

- Solo lo visto hasta la semana 6: clases, `UINavigationController`, `prepare(for:sender:)`,
  `IBOutlet` / `IBAction`.
- Nada de `Combine`, `Codable`, ni persistencia — el objetivo es reforzar el paso de datos
  con un modelo propio, no aprender temas nuevos.
- `VentaModel` debe ser `class` (no `struct`), igual que `ClienteModel`, porque se pasa por
  referencia entre pantallas y se instancia una sola vez antes de llenarlo.

## Formato

Código Swift completo y comentado solo donde aporte (sin explicar lo obvio), usando el mismo
estilo de nombres de variable con prefijo `p` para parámetros de inicializadores
(`pSubtotal`, `pIgv`, etc.), tal como `ClienteModel` usa `pCodigo`, `pApellido`, etc.

## Ejemplo (entrada → salida esperada)

Entrada: Precio unitario = 1000, Cantidad = 3.5 (no aplica, se usa 1 unidad real), Meses = 12,
Interés mensual = 4%

```
subtotal  = 3500.00
igv       = 630.00
base      = 4130.00
intereses = 495.60
total     = 4625.60
cuota     = 385.47
```

---

## Reflexión: ¿qué hizo distinto la IA?

- **¿Por qué `class` y no `struct` para `VentaModel`?** Porque, al igual que `ClienteModel`,
  se pasa de una pantalla a otra a través de `prepare(for:sender:)` y se necesita que ambos
  lados (`ViewController` y `ViewControllerResultado`) puedan referenciar la misma instancia
  sin copiarla en cada paso. Además, al heredar de `NSObject`, es compatible con el patrón que
  usa Interface Builder/Objective-C runtime para outlets y storyboards, algo que un `struct`
  no ofrece de forma nativa.
- **Validación de campos vacíos:** la IA usó `Double(texto ?? "") ?? 0` en vez de `guard let`
  con `return` temprano, para que si el usuario deja un campo vacío el cálculo no truene y
  simplemente use `0` — no se pidió explícitamente, pero evita un crash si se toca "Calcular"
  sin llenar todos los campos.
- **Segue directo vs. código:** a diferencia del Ejercicio 2 (que usaba `self.present(...)`
  manual desde un `IBAction`), aquí el segue `Show` se conecta directamente del botón al
  storyboard (como en el Ejercicio 1), y todo el cálculo se hace dentro de
  `prepare(for:sender:)`, que se dispara automáticamente al tocar "Calcular" — menos código,
  mismo resultado.
