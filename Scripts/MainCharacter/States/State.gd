"""
PATRÓN DE CLASES DE ESTADO 

Clase base o clase abstracta para administrar estados del mainCharacter
Sirve como plantilla para definir la estructura del resto de estados
""" 
extends RefCounted
class_name  State

# Referencia al MainCharacter para poder trabajar con sus variables y métodos
var character:MainCharacter = null

## Constructor
# Para poder hacer referencia en las clases de estados del MainCharacter
func _init(new_character: MainCharacter):
	character = new_character

"""
Lógica de inicio
Comienza animaciones, establece velocidades especiales o administra alguna accion que debe realizar al inicio
SE LLAMA UNA SOLA VEZ AL CAMBIAR DE ESTADO
"""
func enter():
	pass

"""
Lógica de estado
Decide y devuelve un nuevo estado si hay transición de estado
UTILIZAR return self PARA RETORNAR EL MISMO ESTADO
"""
func process(delta)->State:
	return self
	
"""
Lógica de salida
Permite resetear velocidades animaciones al acabar un estado
SOLO SE LLAMA UNA VEZ
"""
func exit():
	pass
