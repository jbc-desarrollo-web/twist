"
Casilla vacía (hueco): no tiene brazos y no gira. Se usa en lugar de nil (patrón Null Object), también para las vecinas que quedan afuera del tablero. En los niveles se escribe con un punto.
"
Class {
	#name : 'TwVacio',
	#superclass : 'TwPieza',
	#category : 'Twist-Modelo',
	#package : 'Twist-Modelo'
}

{ #category : 'forma' }
TwVacio >> direccionesBase [
	^ #() "Un hueco no tiene brazos."
]

{ #category : 'consultas' }
TwVacio >> esVacia [
	^ true "Redefine el de TwPieza: esta casilla sí es un hueco."
]

{ #category : 'giro' }
TwVacio >> puedeRotar [
	^ false "Redefine el de TwPieza: un hueco nunca gira."
]
