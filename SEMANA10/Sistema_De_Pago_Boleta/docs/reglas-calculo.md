# Reglas de cálculo — Boleta de pago

Definición neutral del cálculo, para implementarla igual en la app (Swift) y en el Excel.

## Entradas

| Variable | Tipo | Restricción |
|---|---|---|
| sueldoBasico | decimal | > 0 |
| diasLaborados | entero | 1–30 |
| tieneHijos | booleano | — |
| sistemaPension | enum (ONP / AFP) | — |
| afpElegida | enum (solo si sistemaPension = AFP) | — |
| horasExtra25 | decimal | ≥ 0 |
| horasExtra35 | decimal | ≥ 0 |
| adelantos | decimal | ≥ 0 |

## Parámetros (un solo lugar, no dentro de las fórmulas)

| Parámetro | Valor |
|---|---|
| RMV | 1230.00 |
| % Asignación familiar | 10% de RMV = 123.00 |
| % ONP | 13% |
| % EsSalud | 9% |
| Recargo horas extra 25% | 1.25 |
| Recargo horas extra 35% | 1.35 |
| AFP (fondo / comisión / seguro) | diccionario por AFP, ej. 10.00% / 1.60% / 1.35% |

Regla de redondeo: cada concepto se redondea a 2 decimales antes de sumarse.

## Secuencia de cálculo

```
1. sueldoComputable    = round(sueldoBasico / 30 * diasLaborados, 2)

2. asignacionFamiliar  = tieneHijos ? round(0.10 * RMV, 2) : 0.00
                         (no se prorratea por días)

3. valorHora           = sueldoBasico / 30 / 8

4. horasExtra25Monto   = round(valorHora * 1.25 * horasExtra25, 2)
   horasExtra35Monto   = round(valorHora * 1.35 * horasExtra35, 2)

5. totalRemuneraciones = sueldoComputable + asignacionFamiliar
                        + horasExtra25Monto + horasExtra35Monto

6. Si sistemaPension == ONP:
       onp = round(totalRemuneraciones * 0.13, 2)
       afpFondo = afpComision = afpSeguro = 0.00
   Si sistemaPension == AFP:
       afpFondo    = round(totalRemuneraciones * afp.fondo, 2)
       afpComision = round(totalRemuneraciones * afp.comision, 2)
       afpSeguro   = round(totalRemuneraciones * afp.seguro, 2)
       onp = 0.00

7. pension           = onp + afpFondo + afpComision + afpSeguro
   totalDescuentos   = pension + adelantos

8. netoAPagar         = totalRemuneraciones - totalDescuentos

9. esSaludEmpleador   = round(totalRemuneraciones * 0.09, 2)
```

## Salida (boleta, 3 bloques)

- Remuneraciones: sueldoComputable, asignacionFamiliar, horasExtra25Monto, horasExtra35Monto, totalRemuneraciones
- Retenciones / Descuentos: onp, afpFondo, afpComision, afpSeguro, adelantos, totalDescuentos, netoAPagar
- Aportaciones del empleador: esSaludEmpleador
- Los conceptos que no aplican se muestran en 0.00.

## Validación cruzada (Caso 3)

Sueldo 3000.00, 30 días, con hijos, AFP Ejemplo, 4h extra 25%, 4h extra 35%, adelanto 200.00:

- totalRemuneraciones = 3253.00
- totalDescuentos = 621.27
- netoAPagar = 2631.73
- esSaludEmpleador = 292.77
