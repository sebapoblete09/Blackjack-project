# Fantasy Blackjack

Fantasy Blackjack es un proyecto personal desarrollado con Godot 4 como parte de proceso de aprendizaje en desarrollo de videojuegos.

El objetivo inicial fue implementar una versión funcional del Blackjack clásico, poniendo énfasis en una buena organización del código y una arquitectura sencilla que permita seguir ampliando el proyecto. A futuro, la idea es evolucionarlo hacia un juego de cartas con ambientación de fantasía medieval, incorporando nuevas mecánicas inspiradas en títulos como Balatro.

## Características actuales

- Implementación de las reglas básicas del Blackjack.
- Mazo de 52 cartas con mezcla aleatoria.
- Cálculo automático del valor de cada mano.
- Manejo del valor variable de los ases (1 u 11).
- Lógica del dealer siguiendo las reglas tradicionales.
- Carta oculta del dealer hasta el final de la ronda.
- Detección de victoria, derrota y empate.
- Reinicio de la partida.
- Interfaz desarrollada con los nodos `Control` de Godot.

## Tecnologías utilizadas

- Godot 4
- GDScript
- Git
- GitHub

## Estructura del proyecto

```
.
├── assets/
├── audio/
├── fonts/
├── scenes/
├── scripts/
│   ├── deck.gd
│   └── game_manager.gd
└── project.godot
```

El proyecto está organizado separando la lógica del mazo de la lógica principal del juego, facilitando futuras ampliaciones y el mantenimiento del código.

## Próximas mejoras

- Mejorar la interfaz gráfica.
- Incorporar sprites para las cartas.
- Añadir animaciones al repartir y revelar cartas.
- Implementar efectos de sonido.
- Crear una ambientación de fantasía medieval.
- Agregar modificadores de reglas mediante cartas y reliquias.
- Evolucionar el proyecto hacia un juego de progresión tipo roguelite.

## Cómo ejecutar el proyecto

1. Clonar el repositorio.

```bash
git clone https://github.com/TU_USUARIO/fantasy-blackjack.git
```

2. Abrir el proyecto con Godot 4.
3. Ejecutar la escena principal.
