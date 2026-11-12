# PROMPTS.md — rama ia-assisted

## Consulta 1
- **Contexto:** Expediente aprobado (ver `Expediente.md` en `main`); caso Ventas, UIKit + Core Data, construido primero en la rama `manual`.
- **Tarea:** Generar el proyecto completo (proyecto Xcode, modelo Core Data con las 4 entidades y relaciones, sesión/login/registro, TabBar por rol y las 9 pantallas) con una implementación básica y funcional.
- **Restricciones:** Las reglas de negocio (descuento VIP, IGV 18%, control de stock, anulación con motivo, delete rule Deny) deben coincidir con los ejemplos numéricos resueltos en el expediente.
- **Formato esperado:** Código Swift compilable (`xcodebuild`), un commit por pantalla/sección, sin coautoría de la IA en los commits.
- **Qué se hizo con la respuesta:** Se aceptó la estructura y se verificó compilando tras cada commit; se probó el flujo completo (registro, login, productos, clientes, nueva venta, mis ventas) en el simulador de iPhone.

## Consulta 2
- **Contexto:** Al probar "Nueva venta" en el simulador, el campo Cliente quedaba en blanco después de elegir el Producto, y el botón "Registrar venta" no respondía al toque.
- **Tarea:** Diagnosticar y corregir ambos bugs de UI.
- **Restricciones:** No cambiar el diseño de la pantalla, solo la causa raíz de cada bug.
- **Formato esperado:** Explicación del bug y parche mínimo.
- **Qué se hizo con la respuesta:** Se aceptaron los dos diagnósticos (reutilización de celda compartida entre la fila de Cantidad y las demás filas; el botón quedaba bajo el área táctil del tab bar flotante) y sus fixes (identificador de celda separado para Cantidad, quitar el acceso al `textLabel` heredado, y agregar `contentInset.bottom` a la tabla). Se verificó de nuevo en el simulador que la venta se registra con el cálculo correcto de IGV y total.

## Consulta 3
- **Contexto:** Base funcional ya probada en la rama `manual` (login, registro, CRUD de productos/clientes, venta con reglas de negocio, mis ventas, ventas del equipo, anulación, resumen básico).
- **Tarea:** Traer esa base a la rama `ia-assisted` como punto de partida para mejorar diseño y lógica (pendiente: gráfico de 7 días, ranking de vendedores y stock bajo del Resumen — nivel Reto —, y pulido visual de las pantallas).
- **Restricciones:** No mezclar el historial completo de la rama `manual` (que incluye ejercicios de otras semanas); copiar solo la carpeta del proyecto `VentasTecsup`.
- **Formato esperado:** Un commit que traiga la base, sin tocar el resto del historial de `ai-assisted`.
- **Qué se hizo con la respuesta:** Se aceptó tal cual (`git checkout manual -- SEMANA11/VentasTecsup` + commit). Las mejoras de diseño y lógica quedan pendientes como siguiente paso.

## Consulta 4
- **Contexto:** Resumen del Supervisor en nivel básico (solo 3 indicadores de texto); faltaba el nivel Reto del expediente.
- **Tarea:** Rediseñar la pantalla con tarjetas, un gráfico de barras de los últimos 7 días, un ranking de vendedores del mes (con barra proporcional) y una lista de productos con stock ≤ 5 marcados "Reponer"; todo calculado con fetch requests sobre Core Data, sin datos fijos de ejemplo.
- **Restricciones:** No usar Swift Charts ni dependencias externas (solo UIKit); mantener los mismos cálculos de negocio ya definidos en `ReglasNegocio.swift`.
- **Formato esperado:** Código Swift compilable.
- **Qué se hizo con la respuesta:** Se aceptó el diseño y se verificó en el simulador con datos reales (una venta registrada) que el gráfico, el ranking y el stock bajo se calculan correctamente.

## Consulta 5
- **Contexto:** Pantallas de Productos y Clientes con el mismo aspecto plano de la rama `manual` (un punto de color, sin avatar).
- **Tarea:** Mejorar el diseño acercándolo a la maqueta: insignia de stock con color según umbral en Productos, y avatar circular con iniciales + insignia de categoría (VIP/Frecuente/Regular) en Clientes.
- **Restricciones:** Sin romper la lógica de permisos por rol ya implementada (CRUD solo para Supervisor en Productos, borrado solo para Supervisor en Clientes).
- **Formato esperado:** Código Swift compilable.
- **Qué se hizo con la respuesta:** Se aceptó el diseño, pero al probarlo en el simulador las insignias no se veían (quedaban con tamaño cero como `accessoryView`). Se pidió el diagnóstico, se aceptó el fix (fijar `frame.size` con `intrinsicContentSize` antes de asignarlas) y se verificó en el simulador que ya se muestran correctamente.
