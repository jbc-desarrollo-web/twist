"
Pieza con dos brazos en ángulo recto, como una L. En los niveles se escribe con L.
"
Class {
	#name : 'TwEsquina',
	#superclass : 'TwPieza',
	#category : 'Twist-Modelo',
	#package : 'Twist-Modelo'
}

{ #category : 'forma' }
TwEsquina >> direccionesBase [
	^ #(0 1) "Arriba y derecha, como una L."
]
