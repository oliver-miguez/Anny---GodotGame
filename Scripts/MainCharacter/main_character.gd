extends CharacterBody2D
class_name MainCharacter

@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 300 # Velocidad cuando el player está en el estado de correr
const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta

"""
Se ejecuta al inicio del programa
"""


"""
Función que se ejecuta en cada frame 
"""
func _physics_process(delta):
	if not is_on_floor(): # Aplica gravedad al player  cuando no este en el suelo
		gravity(delta)
		 
	move_and_slide()
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x=100
		
	elif Input.is_action_pressed("ui_left"):
		velocity.x=-100   
	
	else: 
		velocity.x=0
			
	#if is_on_floor() and event.is_action("ui_up"):
		#velocity.y=-1000


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
Función que aplica una gravedad al player
"""
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
