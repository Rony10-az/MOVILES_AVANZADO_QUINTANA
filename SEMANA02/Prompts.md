# Prompts utilizados — Laboratorio 02
## Herramienta de IA utilizada
[Claude / ChatGPT / Copilot] 
### Herramienta de IA utilizada
ChatGPT


## Ejercicio 6 — Carrito mejorado
### Prompt (estructura CTRFE):
**CONTEXTO:**  
Estoy desarrollando ejercicios en Swift Playground para un laboratorio de programación. Ya tengo un carrito de compras básico con subtotales, descuentos, IGV y puntos.

**TAREA:**  
Mejorar el carrito agregando reglas más avanzadas de negocio como descuentos por cantidad, cupones, envío gratis y puntos de fidelidad.

**RESTRICCIONES:**  
- Usar Swift  
- No usar librerías externas  
- Validar datos (precio y cantidad)  
- Aplicar lógica paso a paso  
- Código entendible para estudiante  

**FORMATO:**  
Código Swift con comentarios en cada línea explicando la lógica.

**EJEMPLO:**  
Si compra 3 o más productos aplicar 5% de descuento adicional.

### ¿Funcionó a la primera?
[Sí/No — qué corregiste]
Si, pero luego hice ajustes en el orden de los descuentos y en cómo se calculaba el subtotal final.
### ¿La IA usó algo que no conocías?
[Sí/No — qué investigaste]
Sí, aprendí mejor cómo encadenar descuentos sobre un mismo subtotal sin perder consistencia en los cálculos.


## Ejercicio 7 — Juego de adivinanza
### Prompt (estructura CTRFE):
**CONTEXTO:**  
Estoy aprendiendo estructuras de control en Swift (while, if, repeat-while) en Xcode Playground.

**TAREA:**  
Crear un juego de adivinanza de número secreto usando 5 intentos simulados con variables.

**RESTRICCIONES:**  
- Usar Swift  
- Usar while  
- No usar input del usuario  
- Comparar cada intento con un número secreto fijo  
- Contar intentos  
- Mostrar mensajes “Muy alto”, “Muy bajo” o “Correcto”

**FORMATO:**  
Código Swift con comentarios en cada línea explicando la lógica.

**EJEMPLO:**  
Número secreto = 42, intentos simulados como 20, 50, etc.

---
### ¿Funcionó a la primera?
[Sí/No — qué corregiste]
Sí, la estructura funcionó bien, pero ajusté el uso del array para recorrer los intentos más fácilmente.
### ¿La IA usó algo que no conocías?
[Sí/No — qué investigaste]
Sí, aprendí una forma más ordenada de simular intentos usando arrays y control de índices dentro de un while.
