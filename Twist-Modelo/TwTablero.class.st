"
Soy la cuadrícula del juego: un arreglo de filas de piezas (composición).

Sé si una conexión está cerrada (brazo, brazo de vuelta en la vecina y mismo color), cuántos brazos quedan sueltos, si el nivel está resuelto y cómo mezclarlo.
"
Class {
	#name : 'TwTablero',
	#superclass : 'Object',
	#instVars : [
		'filas'
	],
	#category : 'Twist-Modelo',
	#package : 'Twist-Modelo'
}

{ #category : 'creacion' }
TwTablero class >> conFilas: unasFilas [
	^ self new filas: unasFilas "Crea un tablero a partir de un arreglo de filas de piezas."
]

{ #category : 'consultas' }
TwTablero >> cantidadDeColumnas [
	^ filas first size "Es rectangular: alcanza con medir la primera fila."
]

{ #category : 'reglas' }
TwTablero >> cantidadDeConexionesSueltas [ "Cuenta los brazos sin conectar. Cero quiere decir resuelto."
	| sueltas | "Contador."
	sueltas := 0. "Arranca en cero."
	1 to: self cantidadDeFilas do: [ :unaFila | "Cada fila,"
		1 to: self cantidadDeColumnas do: [ :unaColumna | "cada columna"
			(self piezaEnFila: unaFila columna: unaColumna) conexiones do: [ :direccion | "y cada brazo de la pieza:"
				(self conexionCerradaEnFila: unaFila columna: unaColumna hacia: direccion) "¿está cerrado este brazo?"
					ifFalse: [ sueltas := sueltas + 1 ] ] ] ]. "Si no, suma uno."
	^ sueltas "El total."
]

{ #category : 'consultas' }
TwTablero >> cantidadDeFilas [
	^ filas size "Cantidad de filas."
]

{ #category : 'reglas' }
TwTablero >> conexionCerradaEnFila: unaFila columna: unaColumna hacia: unaDireccion [ "Responde si ese brazo está conectado con la vecina."
	| pieza vecina | "La pieza y su vecina."
	pieza := self piezaEnFila: unaFila columna: unaColumna. "Buscamos la pieza."
	vecina := self vecinaDeFila: unaFila columna: unaColumna hacia: unaDireccion. "Buscamos la vecina."
	^ (pieza tieneConexionHacia: unaDireccion) "Tres condiciones: la pieza tiene el brazo,"
		and: [ (vecina tieneConexionHacia: (unaDireccion + 2) \\ 4) "la vecina tiene el brazo de vuelta (opuesta: más 2, módulo 4)"
			and: [ vecina color = pieza color ] ] "y las dos son del mismo color."
]

{ #category : 'consultas' }
TwTablero >> contieneFila: unaFila columna: unaColumna [ "Responde si la posición está dentro del tablero."
	^ (unaFila between: 1 and: self cantidadDeFilas) "between:and: incluye los extremos..."
		and: [ unaColumna between: 1 and: self cantidadDeColumnas ] "...y and: solo evalúa el bloque si lo primero dio true."
]

{ #category : 'reglas' }
TwTablero >> estaResuelto [
	^ self cantidadDeConexionesSueltas = 0 "Resuelto: ningún brazo suelto."
]

{ #category : 'inicializacion' }
TwTablero >> filas: unasFilas [
	filas := unasFilas "Guarda las filas."
]

{ #category : 'acciones' }
TwTablero >> girarAlAzar [ "Gira cada pieza entre 0 y 3 veces al azar."
	filas do: [ :unaFila | "Cada fila"
		unaFila do: [ :pieza | (4 atRandom - 1) timesRepeat: [ pieza rotar ] ] ] "y cada pieza: 4 atRandom da 1 a 4; menos 1, de 0 a 3 giros."
]

{ #category : 'acciones' }
TwTablero >> mezclar [ "Gira piezas al azar hasta que el tablero quede sin resolver."
	self tienePiezasQueGiran ifFalse: [ ^ self ]. "Si nada gira, el ciclo de abajo no terminaría nunca."
	self girarAlAzar. "Primera mezcla."
	[ self estaResuelto ] whileTrue: [ self girarAlAzar ] "Si por casualidad quedó resuelto, otra vez."
]

{ #category : 'consultas' }
TwTablero >> piezaEnFila: unaFila columna: unaColumna [
	^ (filas at: unaFila) at: unaColumna "Pieza de esa casilla. Las colecciones de Smalltalk empiezan en 1."
]

{ #category : 'acciones' }
TwTablero >> rotarFila: unaFila columna: unaColumna [
	^ (self piezaEnFila: unaFila columna: unaColumna) rotar "El tablero delega: la que sabe girar es la pieza."
]

{ #category : 'reglas' }
TwTablero >> tienePiezasQueGiran [ "Responde si alguna pieza se puede girar."
	filas do: [ :unaFila | unaFila do: [ :pieza | pieza puedeRotar ifTrue: [ ^ true ] ] ]. "Con encontrar una alcanza."
	^ false "No había ninguna: eran todos huecos."
]

{ #category : 'consultas' }
TwTablero >> vecinaDeFila: unaFila columna: unaColumna hacia: unaDireccion [ "Pieza vecina en esa dirección. Si queda afuera, un hueco."
	| filaVecina columnaVecina | "Posición de la vecina."
	filaVecina := unaFila + (#(-1 0 1 0) at: unaDireccion + 1). "Arriba resta una fila y abajo suma una (más 1 porque el arreglo empieza en 1)."
	columnaVecina := unaColumna + (#(0 1 0 -1) at: unaDireccion + 1). "Derecha suma una columna e izquierda resta una."
	(self contieneFila: filaVecina columna: columnaVecina) ifFalse: [ ^ TwVacio new ]. "Afuera: un hueco, que nunca cierra una conexión."
	^ self piezaEnFila: filaVecina columna: columnaVecina "Adentro: la pieza que hay ahí."
]
