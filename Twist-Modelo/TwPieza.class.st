"
Soy una pieza del tablero (clase abstracta: se usan mis subclases). Sé hacia dónde apuntan mis brazos y cómo girar un cuarto de vuelta.

Direcciones: 0 arriba, 1 derecha, 2 abajo, 3 izquierda. Girar en sentido horario es sumar 1 y quedarse con el resto de dividir por 4.

- orientacion: cuartos de vuelta respecto de mi forma base (0 a 3).
- color: mi grupo de conexiones ($a, $b o $c). El color real lo decide la vista.

Cada subclase define su forma en direccionesBase.
"
Class {
	#name : 'TwPieza',
	#superclass : 'Object',
	#instVars : [
		'orientacion',
		'color'
	],
	#category : 'Twist-Modelo',
	#package : 'Twist-Modelo'
}

{ #category : 'consultas' }
TwPieza >> color [
	^ color "Grupo de color de la pieza."
]

{ #category : 'inicializacion' }
TwPieza >> color: unColor giro: unGiro [ "Configura la pieza con lo que leyó el analizador. Sin ^ devuelve la pieza misma (self)."
	color := unColor. "Grupo de color: $a, $b o $c."
	orientacion := unGiro "Cuartos de vuelta en sentido horario."
]

{ #category : 'conexiones' }
TwPieza >> conexiones [
	^ self direccionesBase collect: [ :direccion | (direccion + orientacion) \\ 4 ] "A cada brazo le sumamos el giro; con el resto de dividir por 4 el 4 vuelve a ser 0."
]

{ #category : 'forma' }
TwPieza >> direccionesBase [
	^ self subclassResponsibility "Método abstracto: cada subclase define sus brazos sin girar."
]

{ #category : 'consultas' }
TwPieza >> esVacia [
	^ false "Una pieza común no es un hueco. TwVacio responde lo contrario."
]

{ #category : 'inicializacion' }
TwPieza >> initialize [ "Pharo llama a este método al hacer new."
	super initialize. "Primero la inicialización de la superclase."
	orientacion := 0. "Sin girar."
	color := $a "Primer grupo de color."
]

{ #category : 'giro' }
TwPieza >> puedeRotar [
	^ true "Toda pieza gira. TwVacio redefine este método."
]

{ #category : 'giro' }
TwPieza >> rotar [ "Gira un cuarto de vuelta. Devuelve true si giró."
	self puedeRotar ifFalse: [ ^ false ]. "Si no puede girar, cortamos avisando que no hubo movimiento."
	orientacion := (orientacion + 1) \\ 4. "Un cuarto de vuelta más, siempre entre 0 y 3."
	^ true "Hubo movimiento."
]

{ #category : 'conexiones' }
TwPieza >> tieneConexionHacia: unaDireccion [
	^ self conexiones includes: unaDireccion "¿Hay un brazo hacia esa dirección?"
]
