# Expediente del trabajo — Laboratorio 11, Parte VIII

## 1. Integrantes y caso

- **Integrante:** Rony Quintana
- **Curso:** Programación en Móviles Avanzado — 5 C24
- **Docente:** Juan León
- **Grupo:** A
- **Caso:** Ventas — UIKit + Core Data
- **Nombre de la app:** Ventas Tecsup
- **Roles:** Vendedor y Supervisor
- Github : https://github.com/Rony10-az/MOVILES_AVANZADO_QUINTANA/tree/main/SEMANA11

## 2. Modelo de datos

4 entidades en el archivo `.xcdatamodeld`, con relaciones y delete rules según el documento del laboratorio.

```
┌───────────────┐          ┌───────────────┐
│    Usuario    │          │   Producto    │
│───────────────│          │───────────────│
│ nombre        │          │ nombre        │
│ usuario       │          │ categoria     │
│ clave         │          │ precio        │
│ rol           │          │ stock         │
└───────┬───────┘          └───────┬───────┘
        │ ventas (To Many, Deny)   │ ventas (To Many, Deny)
        │                          │
        │        ┌───────────────┐ │
        └───────▶ │     Venta     │ ◀┘
                  │───────────────│
                  │ fecha         │
                  │ cantidad      │
                  │ precioUnitario│
                  │ descuento     │
                  │ igv           │
                  │ total         │
                  │ anulada       │
                  │ motivoAnulacion (opcional)
                  └───────┬───────┘
                          │ cliente (To One)
                          ▼
                  ┌───────────────┐
                  │    Cliente    │
                  │───────────────│
                  │ nombre        │
                  │ documento     │
                  └───────────────┘
        (ventas: To Many ▶ Venta, Deny)
```

| Entidad | Atributos | Relaciones |
|---|---|---|
| **Usuario** | nombre, usuario, clave (String), rol (String: Vendedor / Supervisor) | `ventas`: To Many ▶ Venta — delete rule **Deny** |
| **Producto** | nombre, categoria (String), precio (Double), stock (Int) | `ventas`: To Many ▶ Venta — delete rule **Deny** |
| **Cliente** | nombre, documento (String) | `ventas`: To Many ▶ Venta — delete rule **Deny** |
| **Venta** | fecha (Date), cantidad (Int), precioUnitario, descuento, igv, total (Double), anulada (Bool), motivoAnulacion (String, opcional) | `vendedor`: To One ▶ Usuario · `producto`: To One ▶ Producto · `cliente`: To One ▶ Cliente |

Las relaciones `Deny` en Usuario/Producto/Cliente impiden borrar un registro que tenga ventas asociadas; Core Data rechaza el `save()` y la app debe mostrar un mensaje al usuario.

## 3. Roles y permisos

| Qué puede hacer | Vendedor | Supervisor |
|---|---|---|
| **Pestañas** | Productos, Clientes, Venta, Mis ventas, Cuenta | Resumen, Ventas, Productos, Clientes, Cuenta |
| **Productos** | Solo consultar y buscar | Crear, editar y borrar |
| **Clientes** | Crear, editar y consultar | Crear, editar, consultar y borrar |
| **Ventas** | Registrar y ver **solo las suyas** | Ver **todas**, filtrar por vendedor y **anular** con motivo |
| **Resumen** | No lo ve | Panel con indicadores, gráfico y ranking |

La pestaña **Cuenta** (ambos roles) muestra nombre, usuario, rol y el botón **Cerrar sesión**.

## 4. Reglas de negocio (con ejemplo numérico)

1. **Categoría del cliente** (calculada, no se guarda): se calcula sobre el total comprado en ventas **no anuladas**.
   - Regular: < S/ 1,000 · Frecuente: desde S/ 1,000 · VIP: desde S/ 5,000
   - Ejemplo: cliente con S/ 6,240 comprados → categoría **VIP**.

2. **Descuento e IGV**
   - Descuento: 10 % del subtotal si el cliente es VIP; 0 % en los demás casos.
   - IGV: 18 % sobre (subtotal − descuento).
   - Total = subtotal − descuento + IGV.
   - **Ejemplo A (cliente VIP):** 2 Laptop Pro 14 a S/ 200.00 → Subtotal = 400.00 · Descuento = 40.00 · IGV = 18 % × 360.00 = 64.80 · **Total = 424.80**.
   - **Ejemplo B (cliente Regular):** 3 Mouse a S/ 35.00 → Subtotal = 105.00 · Descuento = 0.00 · IGV = 18.90 · **Total = 123.90**.

3. **Stock:** al registrar una venta se descuenta del stock del producto. Si la cantidad pedida supera el stock disponible, se muestra una alerta y la venta **no se registra**.
   - Ejemplo: producto con stock 40, se pide una venta de 50 unidades → alerta "Stock insuficiente", stock permanece en 40.

4. **Anulación (solo Supervisor):** exige un motivo obligatorio; marca la venta como `anulada = true`, **devuelve el stock** al producto y la venta deja de contar en reportes y en la categoría del cliente.
   - Ejemplo: se anula la venta del Ejemplo A (stock había bajado de 40 a 38). Sin motivo, el botón Anular permanece deshabilitado. Con motivo "Producto defectuoso": venta queda anulada, stock vuelve a 40, y el total vendido del resumen baja en S/ 424.80.

5. **Visibilidad:** el vendedor solo ve sus propias ventas (`NSPredicate("vendedor == %@", usuarioSesion)`); el supervisor ve todas y puede filtrar por vendedor.

6. **Borrado restringido:** no se puede borrar un Producto, Cliente o Usuario que tenga ventas asociadas (delete rule Deny); se informa con un mensaje al intentarlo.

## 5. Pantallas (9)

| # | Pantalla | Propósito | Qué lee / escribe |
|---|---|---|---|
| A1 | Login | Autenticar con usuario y clave | Lee Usuario (fetch con predicate); escribe la sesión activa |
| A2 | Crear cuenta | Registro con nombre, usuario único, clave (mín. 6) + confirmación y rol | Crea un Usuario nuevo; valida unicidad antes de guardar |
| A3 | Productos | Lista con búsqueda y chips de categoría; color de fila según stock | Lee Producto (fetch + predicate); Supervisor crea/edita/borra |
| A4 | Clientes | Lista de clientes con categoría y total comprado calculado | Lee Cliente y sus Ventas no anuladas; ambos roles crean/editan, solo Supervisor borra |
| A5 | Nueva venta | Formulario: cliente, producto, cantidad con stepper | Lee stock disponible; calcula subtotal/descuento/IGV/total; escribe una Venta y actualiza stock |
| A6 | Mis ventas | Historial propio del vendedor con indicadores hoy/mes | Lee Venta filtrada por `vendedor == sesión` |
| A7 | Ventas del equipo | Todas las ventas, filtro por vendedor, búsqueda por cliente | Lee todas las Venta; Supervisor puede deslizar para anular |
| A8 | Anular venta | Alerta de confirmación con motivo obligatorio | Escribe `anulada = true`, `motivoAnulacion`, devuelve stock |
| A9 | Resumen (Supervisor) | Indicadores, gráfico de 7 días, ranking de vendedores, stock bajo | Lee agregados de Venta y Producto (fetch requests) |

## 6. Casos de prueba

| N.º | Caso | Resultado esperado |
|---|---|---|
| 1 | Registrar "lparedes" como Supervisor e intentar registrar otro "LPAREDES" | Se crea el primero y entra a la app; el segundo se rechaza por usuario repetido |
| 2 | Registrar con claves distintas o de 4 caracteres | Mensaje de error; no se crea el usuario |
| 3 | Login con clave incorrecta | Mensaje "Usuario o clave incorrectos"; no entra |
| 4 | Vendedor registra la venta de 2 Laptop a S/ 200.00 a un cliente VIP | Subtotal 400.00 · descuento 40.00 · IGV 64.80 · total 424.80 · stock 40 a 38 |
| 5 | Vendedor registra 3 Mouse de S/ 35.00 a un cliente Regular | Subtotal 105.00 · IGV 18.90 · total 123.90 |
| 6 | Venta de 50 unidades con stock 40 | Alerta y no se registra; el stock no cambia |
| 7 | Un vendedor abre Mis ventas | Solo aparecen sus ventas y ninguna fila permite Anular |
| 8 | El supervisor anula la venta del caso 4 sin escribir motivo, y luego con motivo | Sin motivo no se puede; con motivo queda anulada, el stock vuelve a 40 y el resumen baja en 424.80 |
| 9 | Borrar un cliente que tiene ventas | Se impide y se muestra un mensaje |
| 10 *(agregado)* | Supervisor filtra "Ventas del equipo" por un vendedor específico | Solo se muestran las ventas de ese vendedor |
| 11 *(agregado)* | Se registra un producto con stock 0 y se intenta vender 1 unidad | Alerta de stock insuficiente; la venta no se registra |

## 7. Plan de commits

Un commit por avance funcional, en este orden, en la rama `ai-assisted`:

1. Proyecto base + modelo de datos Core Data (4 entidades, atributos y relaciones)
2. Sesión (clase compartida) + pantalla de Login (A1)
3. Registro de cuenta (A2) con validaciones de usuario único y clave
4. TabBarController dinámico por rol + pantalla Cuenta
5. Productos (A3): listado, búsqueda, chips de categoría, CRUD según rol
6. Clientes (A4): listado, categoría calculada, CRUD según rol
7. Nueva venta (A5): formulario, cálculo de subtotal/descuento/IGV/total, control de stock
8. Mis ventas (A6): historial del vendedor con indicadores
9. Ventas del equipo (A7) + Anular venta (A8)
10. Resumen del Supervisor (A9): gráfico, ranking, stock bajo
11. Ícono de la app y ajustes visuales finales
12. PROMPTS.md, README y evidencias (capturas, casos de prueba verificados)

## 8. Plan de uso de IA

- **Se pedirá a la IA:** boilerplate de pantallas (table views, formularios, alerts), estructura del modelo de Core Data, cálculos de las reglas de negocio ya definidas en este expediente, y fetch requests/predicates.
- **Se hará a mano / se revisará manualmente:** verificación de que cada regla de negocio implementada coincide con los ejemplos numéricos de la sección 4, ejecución de los 9+2 casos de prueba uno por uno en el simulador, y revisión de que los delete rules y el flujo de roles correspondan a la matriz de permisos (sección 3).
- **Verificación de respuestas de la IA:** compilar tras cada cambio, correr la app en el simulador de iPhone, y confirmar cada caso de prueba contra el resultado esperado antes de hacer commit. Cada consulta relevante a la IA se registra en `PROMPTS.md` con Contexto, Tarea, Restricciones, Formato esperado, y qué se hizo con la respuesta (aceptada, modificada o descartada).

## 9. Visto bueno

- **Fecha de presentación al docente:** _____________
- **Confirmación / firma del docente:** _____________
