extends CharacterBody2D
class_name MainCharacter

@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 300 # Velocidad cuando el player está en el estado de correr

const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta

##Función que se ejecuta en cada frame 
func _physics_process(delta):
	if not is_on_floor(): # Aplica gravedad al player  cuando no este en el suelo
		gravity(delta)
		 
	move_and_slide()

## Movimientos del player
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x=100
		
	elif Input.is_action_pressed("ui_left"):
		velocity.x=-100   
	
	else: 
		velocity.x=0
			
	#if is_on_floor() and event.is_action("ui_up"):
		#velocity.y=-1000

##Función que aplica una gravedad al player
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
