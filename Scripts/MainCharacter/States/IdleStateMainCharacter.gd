"""
Administra el funcionamiento del estado de Idle del MainCharacter
"""
extends State # Extiende de nuetra plantilla State para crear el estado

func enter():
	character.speed = 0 # Velocidad en 0 ya que en estado idle no nos movemos
	
func procces(delta)->State:
	## Administrar a que estados puede cambiar
	return null 
	
func exit():
	character.speed = 100 # Restablece la velocidad cuando finaliza este estado
