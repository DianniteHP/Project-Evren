extends CanvasLayer

func _process(_delta: float) -> void:
	$Control/MarginContainer/Label.text = "acceleration: " + str(Global.acceleration)
