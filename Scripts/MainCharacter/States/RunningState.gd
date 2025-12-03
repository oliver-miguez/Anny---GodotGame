extends State
class_name RunningState

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
