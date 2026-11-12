"
Pruebas del lenguaje de niveles: niveles válidos y un error de cada tipo.
"
Class {
	#name : 'TwNivelesTest',
	#superclass : 'TestCase',
	#category : 'Twist-Tests',
	#package : 'Twist-Tests'
}

{ #category : 'auxiliares' }
TwNivelesTest >> errorAlLeer: unTexto [
	^ [ TwAnalizadorSintactico new tableroDesde: unTexto. nil ] on: TwErrorDeNivel do: [ :error | error messageText ] "Mensaje del error, o nil si no falló."
]

{ #category : 'tests' }
TwNivelesTest >> testErrorLexico [ "La X no pertenece al lenguaje."
	self assert: ((self errorAlLeer: 'E1a X3a') includesSubstring: 'no pertenece') "El mensaje lo dice."
]

{ #category : 'tests' }
TwNivelesTest >> testErrorSemantico [ "El nivel tiene que estar escrito con su solución."
	self assert: ((self errorAlLeer: 'E0a E3a') includesSubstring: 'no está resuelto') "El primer extremo apunta arriba y no hacia el segundo."
]

{ #category : 'tests' }
TwNivelesTest >> testErrorSintactico [ "Después del giro tiene que venir un color."
	self assert: ((self errorAlLeer: 'R1 L2a') includesSubstring: 'esperaba un color') "El mensaje dice qué faltaba."
]

{ #category : 'tests' }
TwNivelesTest >> testNivelesDeFabricaSonValidos [ "Los tres niveles se leen sin errores y están escritos resueltos."
	TwJuego nivelesDeFabrica do: [ :texto | self assert: (TwAnalizadorSintactico new tableroDesde: texto) estaResuelto ] "Leemos cada uno y controlamos."
]
