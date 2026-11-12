# PROMPTS.md — rama manual

## Consulta 1
- **Contexto:** Expediente ya aprobado (ver `Expediente.md` en `main`); caso Ventas, UIKit + Core Data.
- **Tarea:** Generar el proyecto base (estructura Xcode moderna sin storyboard principal), el modelo Core Data con las 4 entidades/relaciones del expediente, y las 9 pantallas con una versión básica y funcional (alertas para formularios, tablas simples), siguiendo el mismo estilo que el laboratorio 1 ya resuelto en clase.
- **Restricciones:** Mantener el nivel "básico" (sin gráfico, sin ranking); reglas de negocio (descuento VIP, IGV 18%, control de stock, anulación con motivo) deben coincidir con los ejemplos numéricos del expediente.
- **Formato esperado:** Código Swift compilable, un commit por pantalla/sección.
- **Qué se hizo con la respuesta:** Se aceptó la estructura general. Se verificó compilando con `xcodebuild` tras cada commit y se probó el flujo completo (registro, login, productos, clientes, venta) en el simulador.

## Consulta 2
- **Contexto:** Al probar "Nueva venta" en el simulador, el campo Cliente quedaba en blanco después de elegir el Producto.
- **Tarea:** Diagnosticar y corregir el bug.
- **Restricciones:** No cambiar el diseño de la pantalla, solo la causa raíz.
- **Formato esperado:** Explicación del bug + parche mínimo.
- **Qué se hizo con la respuesta:** Se aceptó el diagnóstico (reutilización de celda compartida entre la fila de Cantidad y las demás filas) y el fix (identificador de celda separado, quitar acceso a `textLabel` heredado). Se verificó de nuevo en el simulador que el bug ya no ocurre y que la venta se registra con el cálculo correcto.
