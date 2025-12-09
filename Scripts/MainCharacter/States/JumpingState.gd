extends "res://Scripts/GeneralStates/Util/State.gd"

@export var fall_state:State

func on_enter():
	animation_player.play("Jump")

func state_process(_delta: float) -> void:
	pass
