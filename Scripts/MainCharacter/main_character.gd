extends CharacterBody2D
class_name MainCharacter

@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 300 # Velocidad cuando el player está en el estado de correr
const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta

var current_state:State = null  # Administra el estado en el que se encuentra el player

# ESTADOS
const Idle_State = preload("res://Scripts/MainCharacter/States/IdleState.gd")
const Walking_State = preload("res://Scripts/MainCharacter/States/WalkingState.gd")
const Jumping_State = preload("res://Scripts/MainCharacter/States/JumpingState.gd")
const Crouching_State = preload("res://Scripts/MainCharacter/States/CrouchingState.gd")
const Running_State = preload("res://Scripts/MainCharacter/States/RunningState.gd")
const Falling_State = preload("res://Scripts/MainCharacter/States/FallingState.gd")

"""
Se ejecuta al inicio del programa
"""
func _ready():
	change_state(Idle_State.new(self)) # Estado inicial
	
	# Arreglar posibles fallos con la velocidad nula
	if speed == null:
		speed = 100

"""
Administra la transición de estados del MainCharacter
"""
func change_state(new_state:State):
	#Si el estado actual no existe o es nulo
	if current_state != null:
		current_state.exit() # LLama al cierre o al reseteo del estado
		
	current_state = new_state # Reasigna el nuevo estado
	current_state.enter() # Cambia e introduce el nuevo estado
	# BUG ERROR CON EL ESTADO, NO ME CAMBIA CORRECTAMENTE
	print("Nuevo estado:"+current_state.name) # DEBUG

"""
Función que se ejecuta en cada frame 
"""
func _physics_process(delta):
	if not is_on_floor(): # Aplica gravedad al player  cuando no este en el suelo
		gravity(delta) 

	var next_state = current_state.process(delta) # Transición de estado

	if next_state != current_state: # Cambia de estado
		change_state(next_state)
	
	player_movement() # Permite el movimiento del player
	player_animations() # Llama a la función que permite el ejecutar la animaciones del player 

"""
Modifica la velocidad base a una de aceleración o carrera

Util para el estado Running del MainCharacter
"""
func enter_run():
	speed = running_speed

"""
Restablece la velocidad de carrera a una velocidad normal de movimiento

Util para reestablecer la velocidad tras cambiar del estado Running de MainCharacter
"""
func exit_run():
	speed = 100

"""
Ajusta la velocidad de movimiento, para evitar que se mueva el personaje

Util para el estado de Crouching del MainCharacter
"""
func crouch_no_velocity():
	velocity.x = 0 # evita que el player se mueva cuando esta agachado

"""
Reestablece la velocidad a la normal

Util para cuando cambiamos del estado Crouching del MainCharacter
"""
func crouch_velocity():
	velocity.x = speed

"""
Proporciona un impulso para realizar el salto
Introduce un efecto de sonido para el salto

Util para el estado Jumping del MainCharacter
"""
func jump():
	jump_sound.play()
	velocity.y -= jump_force

## Estado callendo
# Aplica una gravedad
func fall():
	pass

"""
Administra como funciona el movimiento del MainCharacter
"""
func player_movement():
	var direction := Input.get_action_strength("Right_Input") - Input.get_action_strength("Left_Input")
	var max_velocity_speed = speed # Para establecer la velocidades correctamente en cada estados
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, direction * max_velocity_speed, 0.2) # Movimiento suave
		# Nota: la línea if direction == 0: velocity.x = 0; ya no es necesaria 
		# si usas lerp, ya que lerp(x, 0, 0.2) lo lleva a cero.
	else:
		if direction != 0: # Control aéreo
			velocity.x = lerp(velocity.x, direction * max_velocity_speed, 0.1)
			
	# Mover al personaje
	move_and_slide()

"""
Animaciones del player

¡NOTA!
 Sigue siendo importante porque a pesar que en el enter() de cada estado se puedan iniciar las animaciones
 Seguira siendo util para hacer flip 
"""
func player_animations():
	# Administra el flip de las animaciones del sprite del MainCharacter
	if velocity.x > 0:
		main_character_animations.flip_h = false
	elif velocity.x < 0:
		main_character_animations.flip_h = true
	
	match current_state.get_class():
		"IdleState":
			main_character_animations.play("Idle")
		"WalkingState":
			main_character_animations.play("Walk")
		"RunningState":
			main_character_animations.play("Run")
		"JumpingState":
			main_character_animations.play("Jump")
		"FallingState":
			main_character_animations.play("Jump")
		"CrouchingState":
			main_character_animations.play("Crouch")

"""
Función que aplica una gravedad al player
"""
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
