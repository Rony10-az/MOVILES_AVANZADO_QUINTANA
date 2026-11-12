# Laboratorio 05 – Actividad: Calculadora de Préstamos

App iOS en UIKit con Storyboard que calcula la cuota mensual y el monto total de un préstamo.

Entradas: capital (P), tasa anual (%) y plazo (años). Se usa:

- `r = tasa anual / 100 / 12` (tasa mensual)
- `n = años × 12` (número de pagos)
- `M = P · r(1+r)^n / ((1+r)^n − 1)` (cuota mensual; si `r = 0`, `M = P / n`)
- Monto total a pagar = `M × n`

Verificación: P = 10 000, tasa 12 %, plazo 5 años → cuota **222.44**, total **13 346.67**.

Captura de la pantalla inicial: [capturas/pantalla_inicial.png](capturas/pantalla_inicial.png)
