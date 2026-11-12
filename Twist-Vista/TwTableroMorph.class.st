"
Vista Morphic: dibuja el juego y convierte los clics en mensajes para TwJuego. No contiene reglas.

	TwTableroMorph abrir.
	TwTableroMorph abrirJuego: (TwJuego conNiveles: #('E1a E3a')).

Clic en una pieza: la gira.
"
Class {
	#name : 'TwTableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'juego'
	],
	#category : 'Twist-Vista',
	#package : 'Twist-Vista'
}

{ #category : 'apertura' }
TwTableroMorph class >> abrir [
	^ self abrirJuego: TwJuego deFabrica "Abre el juego con sus tres niveles."
]

{ #category : 'apertura' }
TwTableroMorph class >> abrirJuego: unJuego [ "Crea la vista de una partida y la abre en una ventana."
	^ self new juego: unJuego; openInWindowLabeled: 'Twist'; yourself "Cascada (;): los tres mensajes van al morph nuevo; yourself lo devuelve."
]

{ #category : 'dibujo' }
TwTableroMorph >> colorPara: unaPieza [ "Color real del grupo. El modelo no sabe de colores de pantalla."
	unaPieza color = $a ifTrue: [ ^ Color r: 0.88 g: 0.44 b: 0.6 ]. "Grupo a: rosa."
	unaPieza color = $b ifTrue: [ ^ Color r: 0.25 g: 0.65 b: 0.55 ]. "Grupo b: verde."
	^ Color r: 0.3 g: 0.5 b: 0.85 "Grupo c: azul."
]

{ #category : 'dibujo' }
TwTableroMorph >> dibujarFila: unaFila columna: unaColumna en: aCanvas [ "Dibuja una casilla: fondo, brazos y círculo central."
	| pieza casilla colorPieza | "La pieza, su lugar en pantalla y su color."
	pieza := juego tablero piezaEnFila: unaFila columna: unaColumna. "Pieza del modelo."
	casilla := self rectanguloDeFila: unaFila columna: unaColumna. "Lugar en pantalla."
	aCanvas fillRectangle: (casilla insetBy: 3) color: (pieza esVacia ifTrue: [ Color darkGray ] ifFalse: [ Color white ]). "Fondo un poco más chico: gris oscuro si es hueco, blanco si no."
	pieza esVacia ifTrue: [ ^ self ]. "Los huecos no llevan nada más."
	colorPieza := self colorPara: pieza. "Color real del grupo."
	pieza conexiones do: [ :direccion | "Un brazo por conexión:"
		aCanvas line: casilla center to: (self puntoDelBorde: casilla hacia: direccion) width: 12 "línea gruesa del centro al borde exacto,"
			color: ((juego tablero conexionCerradaEnFila: unaFila columna: unaColumna hacia: direccion) "de color fuerte si el brazo está conectado"
				ifTrue: [ colorPieza ] ifFalse: [ colorPieza alpha: 0.35 ]) ]. "y transparente si está suelto."
	aCanvas fillOval: (casilla center - 10 extent: 20 asPoint) color: colorPieza "Círculo en el centro."
]

{ #category : 'dibujo' }
TwTableroMorph >> drawOn: aCanvas [ "Morphic llama a este método cada vez que hay que dibujar."
	super drawOn: aCanvas. "Morph pinta el fondo."
	juego isNil ifTrue: [ ^ self ]. "Sin partida no hay nada más."
	1 to: juego tablero cantidadDeFilas do: [ :unaFila | "Cada fila"
		1 to: juego tablero cantidadDeColumnas do: [ :unaColumna | self dibujarFila: unaFila columna: unaColumna en: aCanvas ] ] "y cada columna."
]

{ #category : 'eventos' }
TwTableroMorph >> festejar [ "Avisa que se completó el nivel y pasa al siguiente."
	self inform: 'Nivel completado en ' , juego movimientos printString , ' movimientos.'. "Mensaje con los movimientos."
	juego pasarAlSiguienteNivel. "Si hay otro nivel, lo carga."
	self changed "Redibujamos."
]

{ #category : 'eventos' }
TwTableroMorph >> handlesMouseDown: unEvento [
	^ true "Le decimos a Morphic que queremos recibir los clics."
]

{ #category : 'inicializacion' }
TwTableroMorph >> initialize [ "Tamaño y color de fondo."
	super initialize. "Inicialización de Morph."
	self color: (Color r: 0.85 g: 0.9 b: 0.86). "Fondo verde claro."
	self extent: (self margen * 2 + (5 * self tamanioDeCasilla)) asPoint "Cuadrado, pensado para el tablero más grande (5 x 5)."
]

{ #category : 'inicializacion' }
TwTableroMorph >> juego: unJuego [ "Guarda la partida y pide redibujar."
	juego := unJuego. "La partida."
	self changed "changed le avisa a Morphic que hay que redibujar."
]

{ #category : 'medidas' }
TwTableroMorph >> margen [
	^ 20 "Espacio alrededor del tablero."
]

{ #category : 'eventos' }
TwTableroMorph >> mouseDown: unEvento [ "Morphic llama a este método con cada clic: lo traducimos a una casilla."
	| casilla | "Columna y fila del clic, como un punto."
	casilla := unEvento position - self position - self margen // self tamanioDeCasilla + 1. "Relativo al tablero y dividido (//, división entera) por el lado de la casilla; más 1 porque empiezan en 1."
	(juego tocarFila: casilla y columna: casilla x) ifFalse: [ ^ self ]. "Si no hubo movimiento (hueco o afuera), nada que redibujar."
	self changed. "Redibujamos."
	juego nivelTerminado ifTrue: [ self festejar ] "Si se resolvió, festejamos."
]

{ #category : 'dibujo' }
TwTableroMorph >> puntoDelBorde: unRectangulo hacia: unaDireccion [ "Punto medio del lado que mira hacia esa dirección."
	unaDireccion = 0 ifTrue: [ ^ unRectangulo topCenter ]. "Arriba."
	unaDireccion = 1 ifTrue: [ ^ unRectangulo rightCenter ]. "Derecha."
	unaDireccion = 2 ifTrue: [ ^ unRectangulo bottomCenter ]. "Abajo."
	^ unRectangulo leftCenter "Izquierda."
]

{ #category : 'medidas' }
TwTableroMorph >> rectanguloDeFila: unaFila columna: unaColumna [ "Rectángulo que ocupa una casilla en pantalla."
	| origen | "Esquina superior izquierda."
	origen := self position + self margen + (((unaColumna - 1) @ (unaFila - 1)) * self tamanioDeCasilla). "Posición del morph, más el margen, más las casillas anteriores."
	^ origen extent: self tamanioDeCasilla asPoint "extent: arma el rectángulo con esquina y tamaño."
]

{ #category : 'medidas' }
TwTableroMorph >> tamanioDeCasilla [
	^ 80 "Lado de una casilla, en píxeles."
]
