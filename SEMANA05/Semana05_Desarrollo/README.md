# Laboratorio 05 – Ejercicio 2: Calculadora de IMC (Semana05_Desarrollo)

App iOS en UIKit con Storyboard que calcula el Índice de Masa Corporal:

- Campos **Peso (Kg)** y **Altura (m)** (`weightTextField`, `heightTextField`).
- Botón **Mostrar** conectado a la acción `CalcularResultado(_:)`.
- Label `resultLabel` que muestra el IMC y la categoría (Bajo peso, Peso normal, Sobrepeso, Obesidad). Al iniciar muestra "Introduce tu Peso y Altura".
- Validación: si peso o altura son 0 o no válidos, muestra "Por favor, ingresa valores válidos.".

Fórmula: `IMC = peso / (altura × altura)`. Ejemplo del lab: 70 kg y 1.70 m → **24.22 – Peso normal**.

Captura de la pantalla inicial: [capturas/pantalla_inicial.png](capturas/pantalla_inicial.png)
