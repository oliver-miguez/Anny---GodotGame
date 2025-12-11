extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State

func on_enter():
	animation_player.play("Jump")

func state_process(_delta: float) -> void:
	if father.is_on_floor():
		next_state = idle_state
