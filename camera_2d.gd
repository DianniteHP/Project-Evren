extends Camera2D

@export var zoom_size :float = 0.1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Zoom in"):
		$".".zoom += Vector2(zoom_size, zoom_size)
	if event.is_action_pressed("Zoom out"):
		$".".zoom -= Vector2(zoom_size, zoom_size)
