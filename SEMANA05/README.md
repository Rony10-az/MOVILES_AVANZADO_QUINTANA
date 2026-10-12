# Semana 05 – Laboratorio 05: Interfaces mediante UIKit

Curso: Programación en Móviles Avanzado (5 C24) · Docente: Juan León

Este laboratorio se separa en tres apps independientes, cada una con su propio proyecto de Xcode (Swift + Storyboard, iOS 17+):

| Carpeta | Ejercicio | Qué hace |
|---|---|---|
| [apple_lab05_UIKit_intro](apple_lab05_UIKit_intro/README.md) | Ejercicio 1 | Labels con constraints (título, nombre con fondo amarillo y docentes). Incluye la respuesta sobre el JUMP BAR. |
| [Semana05_Desarrollo](Semana05_Desarrollo/README.md) | Ejercicio 2 | Calculadora de IMC con IBOutlet, IBAction y validación de entradas. |
| [Calculadora_Prestamos](Calculadora_Prestamos/README.md) | Actividad | Calculadora de préstamos: cuota mensual por amortización y monto total a pagar. |

## Conceptos practicados

- Creación de proyectos UIKit con Storyboard y SceneDelegate.
- Auto Layout: Center in Safe Area, Top/Bottom Space, Width y Vertical Spacing.
- Conexiones entre Interface Builder y código: `@IBOutlet` (campos y etiquetas) y `@IBAction` (botones).
- Lógica de cálculo en Swift con `Double`, `pow` y `String(format:)`.

## Verificación

- Las tres apps compilan para el simulador de iOS con `xcodebuild`.
- Ejercicio 1 ejecutado en el simulador iPhone 17 Pro; captura en `apple_lab05_UIKit_intro/capturas/`.
- Ejercicio 2 y actividad: pantalla inicial verificada; la fórmula se comprobó numéricamente.
