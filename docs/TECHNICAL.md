# Technical Design Document

## Información general

**Proyecto:** Fantasy Blackjack

**Motor:** Godot 4

**Lenguaje:** GDScript

**Control de versiones:** Git + GitHub

**Arquitectura:** Basada en nodos (Node-Based)

---

# 1. Objetivo

Este documento define las decisiones técnicas del proyecto, incluyendo la estructura de carpetas, convenciones de código y arquitectura general.

Su objetivo es mantener un proyecto consistente, escalable y fácil de mantener durante todo el desarrollo.

---

# 2. Principios del proyecto

Todo el desarrollo deberá seguir los siguientes principios.

## Simplicidad

Se priorizarán soluciones simples antes que arquitecturas complejas.

No se implementarán sistemas pensando en problemas que aún no existen.

---

## Escalabilidad

Cada sistema deberá poder ampliarse sin necesidad de reescribir el proyecto completo.

---

## Responsabilidad única

Cada script debe tener una única responsabilidad.

Ejemplos:

- Deck → administra el mazo.
- GameManager → administra las reglas del juego.
- UI → administra la interfaz.

---

## Código legible

El código debe priorizar la claridad por sobre escribir menos líneas.

---

## Proyecto siempre jugable

La rama principal (`main`) debe permanecer siempre en un estado funcional.

---

# 3. Estructura del proyecto

```
FantasyBlackjack/

assets/
│
├── audio/
├── backgrounds/
├── cards/
├── fonts/
├── icons/
└── ui/

docs/

scenes/

scripts/

screenshots/

project.godot
README.md
```

Esta estructura podrá ampliarse conforme el proyecto crezca.

---

# 4. Arquitectura

Actualmente la arquitectura principal es:

Main Scene

↓

GameManager

↓

Deck

En futuras versiones podrán incorporarse nuevos sistemas independientes como:

- AudioManager
- SaveManager
- UIManager
- ShopManager
- RelicManager

---

# 5. Convenciones de código

## Idioma

Todo el código se escribirá en inglés.

La documentación podrá mantenerse en español.

---

## Variables

Utilizar `snake_case`.

Ejemplo:

```
player_hand
dealer_hand
game_over
```

---

## Funciones

Utilizar verbos descriptivos.

Ejemplo:

```
calculate_hand_value()
draw_card()
update_ui()
```

---

## Escenas

Utilizar nombres descriptivos en minúsculas.

Ejemplo:

```
main.tscn
shop.tscn
battle.tscn
```

---

## Scripts

Cada script utilizará el mismo nombre que el sistema que representa.

Ejemplo:

```
game_manager.gd
deck.gd
```

---

# 6. Organización del código

Siempre que sea posible, los scripts se dividirán en secciones.

Ejemplo:

- Nodes
- Variables
- Godot Lifecycle
- Game Flow
- Game Logic
- UI
- Signals

---

# 7. Control de versiones

Se utilizará Git durante todo el desarrollo.

Buenas prácticas:

- Un commit por funcionalidad terminada.
- Mensajes claros y descriptivos.
- No realizar commits con código roto.

Ejemplos:

```
Add dealer hidden card

Separate deck logic

Improve UI layout
```

---

# 8. Recursos externos

Todo recurso utilizado deberá tener una licencia compatible con el proyecto.

Cuando sea posible se utilizarán recursos propios o de dominio público.

---

# 9. Refactorización

La refactorización forma parte del desarrollo.

Antes de añadir nuevos sistemas se evaluará si el código actual necesita reorganizarse.

---

# 10. Estado del documento

Este documento evolucionará junto con la arquitectura del proyecto.

# Decisiones Técnicas

## DT-001

Se separa la lógica del mazo en `deck.gd` para mantener el principio de responsabilidad única.

Fecha: 30/06/2026

---

## DT-002

La documentación del proyecto se mantendrá en español.

El código se desarrollará completamente en inglés.

Fecha: 30/06/2026