extends CharacterBody2D
class_name MainCharacter



@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 300 # Velocidad cuando el player está en el estado de correr
@export var speed_null = 0 # Para administrar la velocidad del player por ejemplo cuando se agacha, para evitar que se mueva
const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta


## Se ejecuta en cada frame 
func _physics_process(delta):
	if not is_on_floor(): # Aplica gravedad al player  cuando no este en el suelo
		gravity(delta) 

	
	player_movement()
	player_animations() # Llama a la función que permite el ejecutar la animaciones del player 


### Métodos de la máquina de estados
## Estado reposo
func idle():
	print("En el estado Idle")
	pass
## Estado caminando
func walk():
	print("En el estado Walk")
	pass
func punch():
	pass
func shoot():
	pass
	
# Cambia la velocidad, a la velocidad de aceleración
func enter_run():
	speed = running_speed
	
# Restablece la velocidad cuando no corre
func exit_run():
	speed = 100

func take_gun():
	pass
func roll():
	pass

# Estado agacharse, permite cubrirse de peligros, mantiene al player quieto
func crouch_no_velocity():
	velocity.x = speed_null # evita que el player se mueva cuando esta agachado

# Devuelve la velocidad al player cuando deja de estar agachado
func crouch_velocity():
	velocity.x = speed

## Estado saltando
func jump():
	jump_sound.play()
	velocity.y -= jump_force

## Estado callendo
# Aplica una gravedad
func fall():
	if is_on_floor: 
		current_state = main_character_states.IDLE


## Otros métodos
# Se ejecuta cuando se detecta un Input del teclado para mover al main-character
func player_movement():
	var direction := Input.get_action_strength("Right_Input") - Input.get_action_strength("Left_Input")
	var max_velocity_speed = speed # Para establecer la velocidades correctamente en cada estados
	
	if current_state == main_character_states.RUNNING:
		max_velocity_speed = running_speed # Establece la velocidad de carrera cuando detecte el estado de carrera del player
	else:
		max_velocity_speed = speed
	
	if is_on_floor():
			if current_state == main_character_states.CROUCHING:
				velocity.x = 0
			else:
				# Reinicia a la velocidad standar de caminar
				velocity.x = direction * max_velocity_speed
				
				# Si no hay input, ir a 0 (deceleración instantánea/rápida en el suelo)
				if direction == 0:
					velocity.x = 0
	elif current_state == main_character_states.JUMPING or current_state == main_character_states.FALLING:
		# Si hay input, ajusta ligeramente la velocidad, sino, se mantiene la inercia.
		if direction != 0:
			# Aquí usar 'lerp' para un control aéreo suave
			velocity.x = lerp(velocity.x, direction * max_velocity_speed, 0.1)


	
	# Mover al personaje
	move_and_slide()

## Animaciones del player
func player_animations():
	if current_state == main_character_states.JUMPING or current_state == main_character_states.FALLING:
		main_character_animations.play("Jump")
		
	if current_state == main_character_states.WALKING:
		if velocity.x > 0: 
			main_character_animations.play("Walk")
			main_character_animations.flip_h = false
		elif velocity.x < 0: 
			main_character_animations.play("Walk")
			main_character_animations.flip_h = true
			

	elif velocity.x == 0 and is_on_floor(): 
		main_character_animations.play("Idle")
		
	
	if Input.is_action_pressed("Down_Input"):
		main_character_animations.play("Crouch")
		
		
	if current_state == main_character_states.RUNNING:
		if velocity.x > 0:
			main_character_animations.play("Run")
			main_character_animations.flip_h = false
		elif velocity.x < 0:
			main_character_animations.play("Run")
			main_character_animations.flip_h = true
		

## Gravedad que afecta al player 
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
