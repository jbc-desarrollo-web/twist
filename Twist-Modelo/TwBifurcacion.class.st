"
Pieza con tres brazos, como una T: el camino se divide. En los niveles se escribe con T.
"
Class {
	#name : 'TwBifurcacion',
	#superclass : 'TwPieza',
	#category : 'Twist-Modelo',
	#package : 'Twist-Modelo'
}

{ #category : 'forma' }
TwBifurcacion >> direccionesBase [
	^ #(1 2 3) "Derecha, abajo e izquierda, como una T."
]
