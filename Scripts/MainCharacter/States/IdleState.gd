extends "res://Scripts/MainCharacter/States/Util/State.gd"

@export var walk_state:State

func on_enter():
	animation_player.play("Idle")

func state_process(_delta: float) -> void:
	if father.velocity.x!=0:
		next_state=walk_state
