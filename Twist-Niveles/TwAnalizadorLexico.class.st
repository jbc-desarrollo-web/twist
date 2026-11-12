"
Analizador léxico del lenguaje de niveles: recorre el texto carácter por carácter y devuelve la lista de tokens.

Cada token es una asociación tipo -> lexema, por ejemplo #giro -> $1. Los tipos son #tipo, #giro, #color, #vacia, #finDeFila y #fin.

Funciona como un autómata finito de dos estados (normal y comentario). Ignora espacios, líneas vacías y comentarios (desde # hasta el final de la línea).
"
Class {
	#name : 'TwAnalizadorLexico',
	#superclass : 'Object',
	#instVars : [
		'tokens',
		'filaConTokens',
		'enComentario'
	],
	#category : 'Twist-Niveles',
	#package : 'Twist-Niveles'
}

{ #category : 'analisis' }
TwAnalizadorLexico >> procesar: unCaracter [ "Decide qué hacer con un carácter según el estado (normal o comentario)."
	(unCaracter = Character cr or: [ unCaracter = Character lf ]) ifTrue: [ ^ self terminarFila ]. "Un salto de línea cierra la fila, aunque estemos en un comentario."
	enComentario ifTrue: [ ^ self ]. "En un comentario se ignora todo."
	unCaracter = $# ifTrue: [ ^ enComentario := true ]. "El numeral pasa al estado comentario."
	unCaracter isSeparator ifTrue: [ ^ self ]. "Espacios y tabulaciones solo separan."
	tokens add: (self tipoDe: unCaracter) -> unCaracter. "El resto es un token: su tipo y el carácter."
	filaConTokens := true "Esta línea tuvo contenido."
]

{ #category : 'analisis' }
TwAnalizadorLexico >> terminarFila [ "Se llama en cada salto de línea y al final del texto."
	filaConTokens ifTrue: [ tokens add: #finDeFila -> nil ]. "Solo las líneas con contenido generan fin de fila."
	filaConTokens := false. "La línea nueva arranca sin tokens"
	enComentario := false "y fuera de cualquier comentario."
]

{ #category : 'analisis' }
TwAnalizadorLexico >> tipoDe: unCaracter [ "Categoría de token que le corresponde a un carácter."
	unCaracter = $. ifTrue: [ ^ #vacia ]. "Punto: casilla vacía."
	('ERLT' includes: unCaracter) ifTrue: [ ^ #tipo ]. "Letras de piezas."
	('0123' includes: unCaracter) ifTrue: [ ^ #giro ]. "Giros."
	('abc' includes: unCaracter) ifTrue: [ ^ #color ]. "Colores."
	^ TwErrorDeNivel new signal: 'El carácter ''' , unCaracter asString , ''' no pertenece al lenguaje de los niveles.' "Cualquier otro: error léxico."
]

{ #category : 'analisis' }
TwAnalizadorLexico >> tokensDe: unTexto [ "Recorre el texto y devuelve la lista de tokens (asociaciones tipo -> lexema)."
	tokens := OrderedCollection new. "Lista vacía."
	filaConTokens := false. "La línea todavía no tiene tokens."
	enComentario := false. "Estado inicial del autómata: normal."
	unTexto do: [ :unCaracter | self procesar: unCaracter ]. "Procesamos cada carácter."
	self terminarFila. "La última línea puede no terminar en salto de línea."
	tokens add: #fin -> nil. "Marca de final de texto."
	^ tokens "La lista."
]
