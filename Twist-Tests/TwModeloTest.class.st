"
Pruebas de piezas, tablero y partida, incluida una partida completa.
"
Class {
	#name : 'TwModeloTest',
	#superclass : 'TestCase',
	#category : 'Twist-Tests',
	#package : 'Twist-Tests'
}

{ #category : 'auxiliares' }
TwModeloTest >> extremoHacia: unaDireccion color: unColor [
	^ TwExtremo new color: unColor giro: unaDireccion "Sin girar apunta arriba, así que giro = dirección."
]

{ #category : 'auxiliares' }
TwModeloTest >> resolver: unJuego [ "Simula a un jugador: gira cada pieza hasta que quede como en la solución escrita."
	| solucion | "Tablero resuelto que usamos de guía."
	solucion := TwAnalizadorSintactico new tableroDesde: (TwJuego nivelesDeFabrica at: unJuego numeroDeNivel). "El mismo nivel sin mezclar."
	1 to: solucion cantidadDeFilas do: [ :unaFila | "Cada fila"
		1 to: solucion cantidadDeColumnas do: [ :unaColumna | "y cada columna:"
			[ unJuego nivelTerminado or: [ (unJuego tablero piezaEnFila: unaFila columna: unaColumna) conexiones asSet = (solucion piezaEnFila: unaFila columna: unaColumna) conexiones asSet ] ] "¿Ya terminó, o la pieza ya quedó como en la solución?"
				whileFalse: [ unJuego tocarFila: unaFila columna: unaColumna ] ] ] "la tocamos hasta que coincida (o hasta que el nivel se resuelva)."
]

{ #category : 'tests' }
TwModeloTest >> testCuatroGirosVuelvenAlPrincipio [ "Propiedad: cuatro cuartos de vuelta dejan cualquier pieza como estaba."
	(Array with: TwExtremo new with: TwRecta new with: TwEsquina new with: TwBifurcacion new) do: [ :pieza | "Una de cada tipo."
		| antes | "Conexiones antes de girar."
		antes := pieza conexiones asSet. "Las anotamos (como conjunto: el orden no importa)."
		4 timesRepeat: [ pieza rotar ]. "Cuatro giros."
		self assert: pieza conexiones asSet equals: antes ] "Igual que al principio."
]

{ #category : 'tests' }
TwModeloTest >> testPartidaCompleta [ "Se juegan los tres niveles de principio a fin, con el mismo mensaje que usa la vista."
	| juego | "La partida."
	juego := TwJuego deFabrica. "Partida nueva."
	[ self deny: juego nivelTerminado. "Cada nivel arranca mezclado,"
	self resolver: juego. "lo resolvemos"
	self assert: juego nivelTerminado. "y queda terminado."
	juego hayOtroNivel ] whileTrue: [ juego pasarAlSiguienteNivel ]. "Mientras haya otro, pasamos al siguiente."
	self assert: juego numeroDeNivel equals: 3 "Terminamos en el último."
]

{ #category : 'tests' }
TwModeloTest >> testReglasDeConexion [ "Mismo color conecta, distinto color no, y un brazo contra el borde queda suelto."
	| mismo distinto borde | "Tres tableros de una fila."
	mismo := TwTablero conFilas: { { self extremoHacia: 1 color: $a. self extremoHacia: 3 color: $a } }. "Extremos enfrentados, mismo color."
	distinto := TwTablero conFilas: { { self extremoHacia: 1 color: $a. self extremoHacia: 3 color: $b } }. "Iguales, pero de distinto color."
	borde := TwTablero conFilas: { { self extremoHacia: 0 color: $a } }. "Un extremo apuntando afuera (caso límite)."
	self assert: mismo estaResuelto. "Mismo color: resuelto."
	self assert: distinto cantidadDeConexionesSueltas equals: 2. "Distinto color: los dos brazos sueltos."
	self assert: borde cantidadDeConexionesSueltas equals: 1 "Contra el borde: suelto."
]

{ #category : 'tests' }
TwModeloTest >> testTocarHuecoOAfueraNoSumaMovimientos [ "Casos límite: tocar un hueco o afuera no gira nada ni cuenta."
	| juego | "La partida."
	juego := TwJuego deFabrica. "Nivel 1."
	self deny: (juego tocarFila: 2 columna: 2). "La casilla de abajo al medio es un hueco."
	self deny: (juego tocarFila: 9 columna: 9). "Una posición que no existe."
	self assert: juego movimientos equals: 0 "Ninguno contó."
]
