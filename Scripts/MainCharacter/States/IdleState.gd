extends State # Extiende de nuetra plantilla State para crear el estado
class_name IdleState


func enter():
	character.velocity.x = 0 # Velocidad en 0 ya que en estado idle no nos movemos
	# OJO NO USAR speed, ya que como es la velocidad global si la igualamos a 0 jamás se moverá
	
## Administrar a que estados puede cambiar
func process(_delta)->State:
	# Obtener el input del jugador
	var direction := Input.get_axis("Left_Input", "Right_Input")

	if character.is_on_floor():
		# Running
		if direction != 0 and Input.is_action_pressed("Shift"):
			return RunningState.new(character)
			
		# Walking
		elif direction != 0:
			return WalkingState.new(character) # Ajusta la transición del estado 
			
		else:
			return self # Si no hay transición mantiene el estado actual
	else:
		# Falling
		if character.is_on_floor():
			return FallingState.new(character)
		else:
			return self
func exit():
	character.speed = 100 # Restablece la velocidad cuando finaliza este estado, por si acaso (no hace falta del todo)
