"
Analizador sintáctico descendente recursivo, LL(1): un método por regla de la gramática y cada decisión se toma mirando un solo token.

	nivel = fila , { fila } , FIN ;
	fila  = celda , { celda } , FIN_DE_FILA ;
	celda = VACIA | pieza ;
	pieza = TIPO , GIRO , COLOR ;

Construye directamente el TwTablero. Después controla que sea rectangular, que esté escrito resuelto y que tenga alguna pieza (análisis semántico).
"
Class {
	#name : 'TwAnalizadorSintactico',
	#superclass : 'Object',
	#instVars : [
		'tokens',
		'posicion'
	],
	#category : 'Twist-Niveles',
	#package : 'Twist-Niveles'
}

{ #category : 'auxiliares' }
TwAnalizadorSintactico >> actual [
	^ tokens at: posicion "Token que estamos mirando (lookahead), sin consumirlo."
]

{ #category : 'auxiliares' }
TwAnalizadorSintactico >> avanzar [
	posicion := posicion + 1 "Consume el token actual."
]

{ #category : 'reglas de la gramatica' }
TwAnalizadorSintactico >> celda [ "celda = VACIA | pieza. Con mirar un token alcanza para elegir (LL(1))."
	self actual key = #vacia ifFalse: [ ^ self pieza ]. "Si no es un punto, es una pieza."
	self avanzar. "Consumimos el punto"
	^ TwVacio new "y devolvemos el hueco."
]

{ #category : 'auxiliares' }
TwAnalizadorSintactico >> consumir: unTipo esperando: unaDescripcion [ "Si el token es del tipo esperado lo consume y lo devuelve; si no, error sintáctico."
	| token | "Token actual."
	token := self actual. "Lo miramos."
	token key = unTipo ifFalse: [ TwErrorDeNivel new signal: 'Se esperaba ' , unaDescripcion , ' y se encontró ' , (self descripcionDe: token) , '.' ]. "No es el esperado: decimos qué esperábamos y qué vino."
	self avanzar. "Era el esperado: lo consumimos"
	^ token "y lo devolvemos para usar su lexema."
]

{ #category : 'auxiliares' }
TwAnalizadorSintactico >> descripcionDe: unToken [ "Cómo se nombra un token en un mensaje de error."
	unToken key = #finDeFila ifTrue: [ ^ 'el final de la fila' ]. "Los fines no tienen carácter visible:"
	unToken key = #fin ifTrue: [ ^ 'el final del texto' ]. "los nombramos con palabras."
	^ '''' , unToken value asString , '''' "El resto, entre comillas simples (dos comillas seguidas son una dentro de un String)."
]

{ #category : 'auxiliares' }
TwAnalizadorSintactico >> empiezaUnaCelda [
	^ #(#vacia #tipo) includes: self actual key "¿El token actual puede empezar una celda (punto o letra)?"
]

{ #category : 'reglas de la gramatica' }
TwAnalizadorSintactico >> fila [ "fila = celda , { celda } , FIN_DE_FILA"
	| celdas | "Celdas leídas."
	celdas := OrderedCollection new. "Colección vacía."
	celdas add: self celda. "Al menos una celda."
	[ self empiezaUnaCelda ] whileTrue: [ celdas add: self celda ]. "Más celdas mientras el token pueda empezar una."
	self consumir: #finDeFila esperando: 'otra casilla o el final de la fila'. "La fila termina con un fin de fila."
	^ celdas asArray "Como Array."
]

{ #category : 'reglas de la gramatica' }
TwAnalizadorSintactico >> nivel [ "nivel = fila , { fila } , FIN"
	| filas | "Filas leídas."
	filas := OrderedCollection new. "Colección vacía."
	filas add: self fila. "Al menos una fila."
	[ self actual key = #fin ] whileFalse: [ filas add: self fila ]. "Las llaves son un ciclo: más filas hasta FIN."
	^ filas asArray "Como Array, porque el tablero no cambia de tamaño."
]

{ #category : 'reglas de la gramatica' }
TwAnalizadorSintactico >> pieza [ "pieza = TIPO , GIRO , COLOR"
	| tipo giro color | "Un token por parte."
	tipo := self consumir: #tipo esperando: 'una pieza (E, R, L o T) o un punto'. "La letra."
	giro := self consumir: #giro esperando: 'un giro (0, 1, 2 o 3)'. "El giro."
	color := self consumir: #color esperando: 'un color (a, b o c)'. "El color."
	^ (self piezaDeLetra: tipo value) color: color value giro: giro value digitValue "value es el lexema; digitValue pasa $2 al número 2."
]

{ #category : 'auxiliares' }
TwAnalizadorSintactico >> piezaDeLetra: unaLetra [ "Pieza nueva de la clase de la letra (el léxico ya garantizó E, R, L o T)."
	unaLetra = $E ifTrue: [ ^ TwExtremo new ]. "Extremo."
	unaLetra = $R ifTrue: [ ^ TwRecta new ]. "Recta."
	unaLetra = $L ifTrue: [ ^ TwEsquina new ]. "Esquina."
	^ TwBifurcacion new "Queda la T: bifurcación."
]

{ #category : 'analisis' }
TwAnalizadorSintactico >> tableroDesde: unTexto [ "Convierte el texto de un nivel en un tablero. Si hay errores lanza TwErrorDeNivel."
	| filas tablero | "Filas leídas y tablero armado."
	tokens := TwAnalizadorLexico new tokensDe: unTexto. "Etapa léxica: texto a tokens."
	posicion := 1. "Empezamos por el primer token."
	filas := self nivel. "Etapa sintáctica, desde la regla inicial."
	self validarAnchoDe: filas. "Etapa semántica: rectangular."
	tablero := TwTablero conFilas: filas. "Armamos el tablero."
	self validarTablero: tablero. "Etapa semántica: resuelto y con alguna pieza."
	^ tablero "Listo."
]

{ #category : 'validacion' }
TwAnalizadorSintactico >> validarAnchoDe: unasFilas [ "Todas las filas tienen que tener la misma cantidad de casillas."
	1 to: unasFilas size do: [ :numero | "Revisamos cada fila con su número."
		(unasFilas at: numero) size = unasFilas first size ifFalse: [ "Si tiene otro largo que la primera:"
			TwErrorDeNivel new signal: 'La fila ' , numero printString , ' del tablero tiene otra cantidad de casillas que la primera. El tablero tiene que ser rectangular.' ] ] "error semántico."
]

{ #category : 'validacion' }
TwAnalizadorSintactico >> validarTablero: unTablero [ "Controles de significado sobre el tablero armado."
	unTablero estaResuelto ifFalse: [ TwErrorDeNivel new signal: 'El nivel no está resuelto tal como está escrito: quedan ' , unTablero cantidadDeConexionesSueltas printString , ' conexiones sueltas. Los niveles se escriben con la solución y el juego los mezcla al empezar.' ]. "Se escribe resuelto: si quedan brazos sueltos, no tiene la solución que dice tener."
	unTablero tienePiezasQueGiran ifFalse: [ TwErrorDeNivel new signal: 'El nivel necesita al menos una pieza que se pueda girar.' ] "Si son todos huecos, no hay nada para jugar."
]
