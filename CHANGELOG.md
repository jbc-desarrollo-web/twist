# Bitácora de cambios

## 2026-11-12 - Versión reducida

Se redujo el código a la mitad (de 479 a 236 líneas de código, de 147 a 87 métodos) para que todo el equipo pueda leerlo y defenderlo completo. Se conservó el lenguaje de niveles, que es el aporte original.

**Quitado**
- `TwToken` y las posiciones (fila y columna) en los mensajes de error. Ahora cada token es una asociación `tipo -> lexema` (por ejemplo `#giro -> $1`) y los errores dicen qué se esperaba y qué se encontró.
- Las piezas fijas: el atributo `fija`, el token `*` y la regla opcional `[ FIJA ]` de la gramática.
- El encabezado con el contador de movimientos y el reinicio del nivel en la ventana. Los movimientos se siguen contando y se informan al completar cada nivel.
- `abrirConNivel:`. Un nivel propio se abre con `TwTableroMorph abrirJuego: (TwJuego conNiveles: #('...'))`.
- Escribir el tablero de vuelta como texto (`comoTexto`, `printOn:`, `letra`).
- Los niveles 2 y 4: quedan tres niveles (el 1, el viejo 3 y el viejo 5, renumerados 1 a 3).
- El tratamiento especial del salto de línea de Windows (CR LF).

**Cambiado**
- Pruebas: de 31 tests en cinco clases a 8 tests en dos clases (`TwModeloTest`, `TwNivelesTest`). Se mantienen las propiedades, los casos límite, un error de cada tipo y la partida completa.
- Cada explicación del código pasó al final de su línea.

## 2026-11-12 - Primera versión jugable

**Agregado**
- Modelo del juego: jerarquía de piezas (`TwPieza` abstracta con `TwExtremo`, `TwRecta`, `TwEsquina`, `TwBifurcacion` y `TwVacio`), `TwTablero` con la regla de conexiones por color y `TwJuego` con niveles, movimientos y reinicio.
- Lenguaje de niveles en texto: `TwAnalizadorLexico`, `TwAnalizadorSintactico` (descendente recursivo, LL(1)), `TwToken` y `TwErrorDeNivel`, con mensajes que indican fila y columna.
- Cinco niveles de dificultad creciente: de 2x3 con un color hasta 5x5 con tres colores, piezas fijas y huecos.
- Vista Morphic `TwTableroMorph`: clic para girar, clic en el encabezado para reiniciar, brazos sueltos en color claro.
- 31 pruebas SUnit en cinco clases, incluida una partida completa de los cinco niveles.

**Decisiones**
- Los niveles se escriben resueltos y se mezclan al empezar: así todo nivel tiene solución.
- Los colores del modelo son caracteres (`$a`, `$b`, `$c`); la vista decide el color real.
- Las casillas vacías y las vecinas fuera del tablero son objetos `TwVacio` en lugar de `nil` (Null Object).
