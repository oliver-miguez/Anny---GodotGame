extends "res://Scripts/MainCharacter/States/Util/State.gd"

@export var walk_state:State

func on_enter():
	animation_player.play("Idle")

func state_process(_delta: float) -> void:
	if father.velocity.x!=0:
		next_state=walk_state

## Gira el sprite de la animación
func flip_animation():
	var direction = Input.get_axis("ui_left","ui_right")

	if direction > 0:
		animation_player.flip_h = false
	else:
		animation_player.flip_h = true
		
func _physics_process(_delta: float) -> void:
	flip_animation()
