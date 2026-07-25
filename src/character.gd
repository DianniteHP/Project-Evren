extends CharacterBody2D

@export var mass :int = 100

func _input(event: InputEvent) -> void:
	if event.is_action("Accelerate"):
		Global.acceleration += 1
	if event.is_action_released("Accelerate"):
		Global.acceleration = 0
