extends Camera2D

@export var zoomSize :float = 0.1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoomSize in"):
		$".".zoomSize += Vector2(zoomSize, zoomSize)
	if event.is_action_pressed("zoomSize out"):
		$".".zoomSize -= Vector2(zoomSize, zoomSize)
