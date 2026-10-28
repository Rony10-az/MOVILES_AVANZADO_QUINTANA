# Estructura de carpetas

Separación por capa dentro del target `Sistema_De_Pago_Boleta`, para que el cálculo no dependa de la pantalla:

```
Sistema_De_Pago_Boleta/
├── docs/
│   ├── reglas-calculo.md         # definición de las fórmulas (commit 1)
│   └── estructura-carpetas.md    # este archivo
└── Sistema_De_Pago_Boleta/
    ├── Sistema_De_Pago_BoletaApp.swift   # punto de entrada (@main)
    ├── Models/                    # structs de entrada, enums (SistemaPension, TipoAFP), parámetros
    ├── Logic/                     # clase Boleta: todo el cálculo, sin UI
    ├── Views/                     # ContentView y futuras subvistas (formulario, boleta)
    └── Assets.xcassets/
```

## Por qué esta separación

- **Models**: solo datos (qué entra y qué constantes existen). No calcula nada.
- **Logic**: la clase `Boleta` aplica las 9 fórmulas de `reglas-calculo.md` sobre un `Models`. No sabe que existe SwiftUI.
- **Views**: solo pantalla (`@State`, `TextField`, `Picker`, `Button`). Llama a `Logic`, nunca calcula directamente.

Xcode 16 sincroniza estas carpetas automáticamente con el navigator (grupos basados en el sistema de archivos), así que no hace falta re-agregar manualmente cada archivo nuevo al proyecto.
