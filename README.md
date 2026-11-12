# Twist - Grupo 15

Trabajo Integrador de Paradigmas de Programación (UTN-FRRe, 2026).
Implementación del juego **Twist** en Smalltalk con Pharo.

En Twist el tablero es una cuadrícula de piezas con brazos (extremos, rectas, esquinas y bifurcaciones). Cada clic gira una pieza un cuarto de vuelta. El nivel se gana cuando todos los brazos quedan conectados con un brazo vecino **del mismo color**, sin conexiones sueltas.

Lo que agregamos a la consigna:

- **Lenguaje de niveles propio**: los niveles son texto. Un analizador léxico y uno sintáctico (descendente recursivo, LL(1)) los convierten en el tablero. Cualquiera puede escribir un nivel nuevo sin tocar el código.
- **Mensajes de error claros**: si un nivel está mal escrito, el juego dice qué esperaba y qué encontró.
- **Niveles con solución garantizada**: el nivel se escribe ya resuelto y el juego lo mezcla al empezar. Si el texto no está resuelto, el analizador lo rechaza.
- **Huecos** (casillas vacías) y **tres grupos de color**.

Cada línea del código tiene su explicación al final, como comentario.

## Requisitos

- Pharo 13.0 (64 bits). No necesita internet ni paquetes externos.

## Cargar el código

Opción 1: arrastrar `Twist.st` sobre la ventana de Pharo y elegir la opción para instalarlo (fileIn).

Opción 2: en un Playground, evaluar (Ctrl+D) con la ruta correcta:

```smalltalk
CodeImporter evaluateFileNamed: '/ruta/a/Twist.st'.
```

Se crean cuatro paquetes: `Twist-Modelo`, `Twist-Niveles`, `Twist-Vista` y `Twist-Tests`.

## Correr las pruebas

En el System Browser, clic derecho sobre el paquete `Twist-Tests` y **Run tests**. Son 8 tests en dos clases.

## Jugar

En un Playground:

```smalltalk
TwTableroMorph abrir.
```

- Clic sobre una pieza: la gira 90° en sentido horario.
- Los brazos conectados se ven con color fuerte y los sueltos, más claros. Los huecos tienen fondo oscuro.
- Al completar un nivel, el juego avisa en cuántos movimientos se resolvió y pasa al siguiente. Son tres niveles.

## Escribir un nivel propio

Cada línea es una fila del tablero y cada casilla se escribe así:

| Parte | Valores | Significado |
|---|---|---|
| Letra | `E` `R` `L` `T` | Extremo, Recta, esquina (L), bifurcación (T) |
| Giro | `0` `1` `2` `3` | Cuartos de vuelta en sentido horario |
| Color | `a` `b` `c` | Grupo de conexiones (rosa, verde, azul) |
| `.` | | Casilla vacía (hueco) |

Sin girar: el extremo apunta arriba, la recta es vertical, la esquina va arriba y a la derecha (como una L) y la bifurcación va a la derecha, abajo y a la izquierda (como una T).

Lo que va después de `#` es un comentario. Los espacios sirven para alinear.

**El nivel se escribe resuelto**: el juego lo mezcla al empezar.

Gramática (EBNF):

```
nivel = fila , { fila } , FIN ;
fila  = celda , { celda } , FIN_DE_FILA ;
celda = VACIA | pieza ;
pieza = TIPO , GIRO , COLOR ;
```

## Guion para la demo de la defensa

Dos casos válidos y uno inválido, para pegar en un Playground:

```smalltalk
"Válido 1: el juego completo con sus tres niveles (Ctrl+D)"
TwTableroMorph abrir.

"Válido 2: un nivel propio de dos colores (Ctrl+D)"
TwTableroMorph abrirJuego: (TwJuego conNiveles: #('L1a L2a E2b
E0a E0a E0b')).

"Inválido: la X no pertenece al lenguaje. Seleccionar y Print it (Ctrl+P): muestra el mensaje de error"
[ TwJuego conNiveles: #('E1a X3a') ] on: TwErrorDeNivel do: [ :error | error messageText ].
```

Otros errores para mostrar (con el mismo `on:do:` y Print it):

| Texto | Qué responde |
|---|---|
| `R1 L2a` | Se esperaba un color (a, b o c) y se encontró 'L'. |
| `E0a E3a` | El nivel no está resuelto tal como está escrito: quedan 2 conexiones sueltas. ... |
| `E1a E3a` y abajo `E1a` | La fila 2 del tablero tiene otra cantidad de casillas que la primera. ... |
| `. .` | El nivel necesita al menos una pieza que se pueda girar. |

## Estructura del código

| Paquete | Clases | Responsabilidad |
|---|---|---|
| Twist-Modelo | `TwPieza` (abstracta), `TwExtremo`, `TwRecta`, `TwEsquina`, `TwBifurcacion`, `TwVacio`, `TwTablero`, `TwJuego` | Reglas del juego |
| Twist-Niveles | `TwAnalizadorLexico`, `TwAnalizadorSintactico`, `TwErrorDeNivel` | Leer niveles escritos en texto |
| Twist-Vista | `TwTableroMorph` | Dibujar y recibir clics (Morphic) |
| Twist-Tests | `TwModeloTest`, `TwNivelesTest` | Pruebas SUnit |

El modelo no conoce a la vista: se puede jugar desde un Playground sin ventana.

```smalltalk
| juego |
juego := TwJuego deFabrica.
juego tocarFila: 1 columna: 1.
juego tablero cantidadDeConexionesSueltas.
```

## Subirlo a GitHub con Iceberg

1. Crear el repositorio vacío en GitHub.
2. En Pharo: Browse → Iceberg → **New repository** → **Clone from github.com** (o crear uno local y agregarle el remoto).
3. Con el repositorio abierto, **Add package** y agregar los cuatro paquetes `Twist-*`.
4. **Commit** y **Push**. Iceberg guarda el código en formato Tonel (un archivo por clase).
