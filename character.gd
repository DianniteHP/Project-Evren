extends RigidBody2D

@export var rotation_speed :float = 2.0
@export var thrust_power :float = 300.0


func _physics_process(delta: float) -> void:
	var rotate_direction = Input.get_axis("Rotate left", "Rotate right")
	angular_velocity = rotate_direction * rotation_speed
	
	if Input.is_action_pressed("Accelerate"):
		var forward_direction = Vector2.UP.rotated(rotation)
		apply_central_force(forward_direction * thrust_power)
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.play("engineEffect")
	else:
		$AnimatedSprite2D.hide()
		$AnimatedSprite2D.stop()
	Global.speed = linear_velocity.length()
	
