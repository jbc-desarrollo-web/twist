"
Pieza con dos brazos opuestos (un camino recto). En los niveles se escribe con R.
"
Class {
	#name : 'TwRecta',
	#superclass : 'TwPieza',
	#category : 'Twist-Modelo',
	#package : 'Twist-Modelo'
}

{ #category : 'forma' }
TwRecta >> direccionesBase [
	^ #(0 2) "Arriba y abajo: vertical."
]
