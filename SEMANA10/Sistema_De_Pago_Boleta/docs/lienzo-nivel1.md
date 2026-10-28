# Lienzo (wireframe) — Nivel 1

Boceto del layout antes de conectar datos. Una sola pantalla, todo dentro de un `ScrollView` porque no cabe en el alto del celular.

```
┌─────────────────────────────────┐
│  Boleta de ejemplo               │  ← título fijo (no son datos reales)
├─────────────────────────────────┤
│  FORMULARIO                      │
│  Sueldo básico        [______]   │  TextField, teclado decimal
│  Días laborados       [______]   │  TextField
│  ¿Tiene hijos?    (No) (Sí)      │  Picker
│  Sistema de pensión (ONP)(AFP)   │  Picker
│                                   │
│        [   Calcular   ]          │  Button
├─────────────────────────────────┤
│  BOLETA (aparece tras Calcular)  │
│                                   │
│  REMUNERACIONES                  │
│   Sueldo computable      0.00    │
│   Asignación familiar    0.00    │
│   Total remuneraciones   0.00    │
│                                   │
│  RETENCIONES / DESCUENTOS        │
│   ONP                    0.00    │
│   Total descuentos        0.00    │
│   NETO A PAGAR             0.00    │
│                                   │
│  APORTACIONES DEL EMPLEADOR      │
│   EsSalud (9%)            0.00    │
└─────────────────────────────────┘
```

## Qué entra en este commit (solo estructura)

- `ScrollView` → `VStack` con dos secciones vacías: **Formulario** y **Boleta**.
- Placeholders de texto donde después van los `TextField`/`Picker` reales (commit 8) y los montos calculados (commit 9).
- Sin `@State`, sin binding a `Boleta.calcular` todavía — esto es solo el acomodo visual en el canvas de Xcode.

Los campos de AFP, horas extra y adelantos no aparecen aquí: se agregan en el lienzo del nivel 2 (commit 12).
