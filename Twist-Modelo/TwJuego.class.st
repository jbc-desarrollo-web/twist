"
Soy la partida: sé en qué nivel está el jugador, cuántos movimientos lleva y cuándo puede pasar al siguiente. No sé nada de cómo se dibuja el juego.

Los niveles de fábrica están del lado de clase (nivel1, nivel2 y nivel3), escritos en el lenguaje de niveles.
"
Class {
	#name : 'TwJuego',
	#superclass : 'Object',
	#instVars : [
		'niveles',
		'numeroDeNivel',
		'tablero',
		'movimientos'
	],
	#category : 'Twist-Modelo',
	#package : 'Twist-Modelo'
}

{ #category : 'creacion' }
TwJuego class >> conNiveles: unosTextos [
	^ self new niveles: unosTextos "Partida con los niveles que le pasemos (textos)."
]

{ #category : 'creacion' }
TwJuego class >> deFabrica [
	^ self conNiveles: self nivelesDeFabrica "Partida con los tres niveles del juego."
]

{ #category : 'niveles' }
TwJuego class >> nivel1 [ "Un color y un hueco. Los niveles se escriben ya resueltos."
	^ '# Nivel 1: primeros pasos
L1a R1a L2a   # arriba: esquina, recta y esquina (la parte de arriba de la U)
E0a .   E0a   # abajo: dos extremos y un hueco en el medio'
]

{ #category : 'niveles' }
TwJuego class >> nivel2 [ "Dos colores y una bifurcación."
	^ '# Nivel 2: dos colores
L1a R1a E3a   # grupo a (rosa): esquina, recta y extremo
E0a L1b L2b   # punta rosa; el grupo b (verde) empieza con dos esquinas
E1b T2b L3b   # verde: extremo, bifurcación y esquina'
]

{ #category : 'niveles' }
TwJuego class >> nivel3 [ "Cinco por cinco, tres colores y un hueco."
	^ '# Nivel 3: tres colores
E1a T0a R1a L2a E2c   # rosa con una bifurcación; el azul arranca a la derecha
E2b R0a E2b E0a R0c   # dos puntas verdes; el rosa y el azul bajan
R0b E0a R0b L1c T1c   # punta rosa; el azul dobla y se bifurca
L0b T0b L3b E0c R0c   # el verde se une con una bifurcación; punta azul
.   E0b E1c R1c L3c   # hueco; punta verde; el azul cierra abajo'
]

{ #category : 'niveles' }
TwJuego class >> nivelesDeFabrica [
	^ Array with: self nivel1 with: self nivel2 with: self nivel3 "De menor a mayor dificultad."
]

{ #category : 'niveles' }
TwJuego >> cargarNivel: unNumero [ "Lee el nivel, lo mezcla y pone los movimientos en cero."
	numeroDeNivel := unNumero. "Recordamos el número."
	tablero := TwAnalizadorSintactico new tableroDesde: (niveles at: unNumero). "Texto a tablero resuelto."
	tablero mezclar. "Lo desordenamos."
	movimientos := 0 "Movimientos a cero."
]

{ #category : 'niveles' }
TwJuego >> hayOtroNivel [
	^ numeroDeNivel < niveles size "¿Queda algún nivel después de este?"
]

{ #category : 'consultas' }
TwJuego >> movimientos [
	^ movimientos "Piezas giradas en este nivel."
]

{ #category : 'consultas' }
TwJuego >> nivelTerminado [
	^ tablero estaResuelto "Terminado = tablero resuelto."
]

{ #category : 'inicializacion' }
TwJuego >> niveles: unosTextos [ "Guarda los niveles y arranca por el primero."
	niveles := unosTextos. "Guardamos los textos."
	self cargarNivel: 1 "Si el nivel está mal escrito, el analizador lanza TwErrorDeNivel acá."
]

{ #category : 'consultas' }
TwJuego >> numeroDeNivel [
	^ numeroDeNivel "Número del nivel actual."
]

{ #category : 'niveles' }
TwJuego >> pasarAlSiguienteNivel [
	self hayOtroNivel ifTrue: [ self cargarNivel: numeroDeNivel + 1 ] "Carga el próximo, si hay."
]

{ #category : 'consultas' }
TwJuego >> tablero [
	^ tablero "Tablero del nivel actual."
]

{ #category : 'jugadas' }
TwJuego >> tocarFila: unaFila columna: unaColumna [ "El jugador tocó una casilla. Devuelve true si hubo movimiento."
	self nivelTerminado ifTrue: [ ^ false ]. "Nivel terminado: ya no se toca nada."
	(tablero contieneFila: unaFila columna: unaColumna) ifFalse: [ ^ false ]. "Afuera del tablero: nada (caso límite)."
	(tablero rotarFila: unaFila columna: unaColumna) ifFalse: [ ^ false ]. "Un hueco no gira y no cuenta."
	movimientos := movimientos + 1. "Giró: un movimiento más."
	^ true "Hubo movimiento."
]
