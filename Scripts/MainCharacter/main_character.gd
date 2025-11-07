extends CharacterBody2D
class_name MainCharacter

 # Estados del MainCharacter
enum main_character_states {IDLE,WALKING,HITTING,SHOOTING,RUNNING,TAKINGGUN,ROLLING,JUMPING,FALLING,CROUCHING,TAKINGDAMAGE,DEAD}
var current_state = main_character_states.IDLE # Estado inicial

@export var speed = 100 # Velocidad del player
@export var jump_force = 300 # Fuerza con la que salta el player 
@export var running_speed = 160 # Velocidad cuando el player está en el estado de correr

const  GRAVITY_VALUE = 980.0 # Fuerza de gravedad

@onready var main_character_animations = $MainCharacterAnimations # Animaciones del MainCharacter 

@onready var jump_sound = $JumpSound # Sonido que hace cuando salta



## Se ejecuta en cada frame 
func _physics_process(delta):
	if not is_on_floor(): # Aplica gravedad al player  cuando no este en el suelo
		gravity(delta) 

	player_movement() # Llama a la función que permite el movimiento del player

	# Máquina de estados main-character
	match  current_state:
		#Estado IDLE
		main_character_states.IDLE:
			if not is_on_floor(): # FALLING
				current_state = main_character_states.FALLING
			if Input.is_action_just_pressed("Up_Input") and is_on_floor(): # JUMPING
				current_state = main_character_states.JUMPING
				jump()
			elif Input.is_action_pressed("Down_Input") and is_on_floor(): # CROUCHING
				current_state = main_character_states.CROUCHING
			elif Input.is_action_pressed("Shift") and velocity.x != 0: # RUNNING
				enter_run() # Cambia la velocidad a la velocidad de carrera
				current_state = main_character_states.RUNNING
			elif velocity.x > 0 || velocity.x < 0:
				current_state = main_character_states.WALKING # WALKING
			else:
				current_state = main_character_states.IDLE # IDLE

		# Estado Walking
		main_character_states.WALKING:
			if not is_on_floor():
				current_state = main_character_states.FALLING # FALLING
			elif velocity.x == 0:
				current_state = main_character_states.IDLE # IDLE
			elif Input.is_action_just_pressed("Up_Input") and is_on_floor(): # JUMPING
				current_state = main_character_states.JUMPING
				jump()
			elif Input.is_action_pressed("Shift") and velocity.x != 0: # RUNNING
				enter_run()
				current_state = main_character_states.RUNNING
			else:
				current_state = main_character_states.WALKING # WALKING

		main_character_states.CROUCHING:
			if is_on_floor():
				if velocity.x == 0:
					current_state = main_character_states.IDLE # IDLE
				elif velocity.x != 0:
					current_state = main_character_states.WALKING # WALKING
					
		#Estado Hitting
		main_character_states.HITTING:
			punch()
			
		# Estado Shooting
		main_character_states.SHOOTING:
			shoot()
		
		# Estado Running
		main_character_states.RUNNING:
			if not is_on_floor():
				exit_run()
				current_state = main_character_states.FALLING # Falling
			elif velocity.x == 0:
				exit_run()
				current_state = main_character_states.IDLE # IDLE
			elif Input.is_action_just_pressed("Up_Input") and is_on_floor():
				exit_run()
				current_state = main_character_states.JUMPING # JUMPING
				jump()
			elif velocity.x != 0:
				exit_run()
				current_state = main_character_states.WALKING # WALKING
			elif Input.is_action_pressed("Down_Input") and is_on_floor():
				exit_run()
				current_state = main_character_states.CROUCHING # CROUCHING
			
		# Estado TakingGun
		main_character_states.TAKINGGUN:
			take_gun()
			
		# Estado Rolling
		main_character_states.ROLLING:
			roll()

		# Estado Jumping
		main_character_states.JUMPING:
			if velocity.y > 0: # Cuando empieza a caer (la velocidad Y es positiva)
				current_state = main_character_states.FALLING

		# Estado Falling
		main_character_states.FALLING:
			if is_on_floor():
				if velocity.x == 0:
					current_state = main_character_states.IDLE
				elif velocity.x > 0 ||velocity.x < 0 :
					current_state = main_character_states.WALKING
		
		# Estado TakingDamage
		main_character_states.TAKINGDAMAGE:
			pass
		
		# Estado Dead
		main_character_states.DEAD:
			pass


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

# Estado agacharse, permite cubrirse de peligros
func crouch():
	print("En el estado agachado")
	pass
	
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
	# Movimiento horizontal
	var direction := Input.get_action_strength("Right_Input") - Input.get_action_strength("Left_Input")
	velocity.x = direction * speed
	
	# Mover al personaje
	move_and_slide()
	
func player_animations():
	if current_state == main_character_states.JUMPING or current_state == main_character_states.FALLING:
		main_character_animations.play("Jump")
		

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
		
# Gravedad que afecta al player 
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)
	
# Prueba para comprobar que la rama remota funciona
