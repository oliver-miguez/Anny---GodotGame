extends State
class_name WalkingState

"""
Lógica de inicio
Comienza animaciones, establece velocidades especiales o administra alguna accion que debe realizar al inicio
SE LLAMA UNA SOLA VEZ AL CAMBIAR DE ESTADO
"""
func enter():
	character.speed = 100 # Ajusta la velocidad inicial de movimiento

"""
Lógica de estado
Decide y devuelve un nuevo estado si hay transición de estado
UTILIZAR return self PARA RETORNAR EL MISMO ESTADO
"""
func process(_delta)->State:
	if character.is_on_floor():
		# Idle
		if character.velocity.x == 0:
			return IdleState.new(character) # Ajusta la transición del estado 
		
		# Running
		elif character.velocity.x != 0 and Input.is_action_pressed("Shift"):
			return RunningState.new(character)
			
		else:
			return self # Si no hay transición mantiene el estado actual
	else:
		# Falling
		if character.is_on_floor():
			character.fall()
			return FallingState.new(character)
		else:
			return self
	
"""
Lógica de salida
Permite resetear velocidades animaciones al acabar un estado
SOLO SE LLAMA UNA VEZ
"""
func exit():
	pass
